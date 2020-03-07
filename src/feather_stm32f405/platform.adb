with Ada.Real_Time; use Ada.Real_Time;
with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;
with STM32.Timers;  use STM32.Timers;
with STM32.PWM;     use STM32.PWM;
with STM32.ADC;     use STM32.ADC;
with STM32;         use STM32;
with HAL;           use HAL;
with HAL.GPIO;
with Feather_STM32F405;

package body Platform is
    Fan_Speed_GPIO      : GPIO_Point renames Feather_STM32F405.D5;
    Fan_Speed_AF        : constant GPIO_Alternate_Function := GPIO_AF_TIM3_2;
    Fan_Speed_Timer     : Timer renames Timer_3;
    Fan_Speed_Channel   : constant Timer_Channel := Channel_2;
    Fan_Control         : PWM_Modulator;

    Fan_Sense_GPIO      : GPIO_Point renames Feather_STM32F405.D6;
    Fan_Sense_AF        : constant GPIO_Alternate_Function := GPIO_AF_TIM8_1;
    Fan_Sense_Timer     : Timer renames Timer_8;
    Fan_Sense_Channel   : constant Timer_Channel := Channel_1;

    Temp_Sense_GPIO     : GPIO_Point renames Feather_STM32F405.A0;
    Temp_Sense_Channel  : constant Analog_Input_Channel := 4;
    Temp_Sense_Rank     : constant Regular_Channel_Rank := 1;
    Vref_Rank           : constant Regular_Channel_Rank := 2;

    Beep_GPIO           : GPIO_Point renames Feather_STM32F405.D9;
    Beep_AF             : constant GPIO_Alternate_Function := GPIO_AF_TIM4_3;
    Beep_Timer          : Timer renames Timer_4;
    Beep_Channel        : constant Timer_Channel := Channel_3;
    Beep_Control        : PWM_Modulator;

    All_Regular_Conversions : constant Regular_Channel_Conversions :=
        (Temp_Sense_Rank =>
            (Channel => Temp_Sense_Channel, Sample_Time => Sample_144_Cycles),
         Vref_Rank       =>
            (Channel => Vref_Channel,       Sample_Time => Sample_144_Cycles));

    type ADC_Values is array (All_Regular_Conversions'Range) of UInt16;

    procedure Configure_ADC is
    begin
        Enable_Clock (Temp_Sense_GPIO);
        Configure_IO (Temp_Sense_GPIO,
            (Mode => Mode_Analog,
             Resistors => Floating));
        
        Enable_Clock (ADC_1);
        Reset_All_ADC_Units;

        Configure_Common_Properties
            (Mode           => Independent,
             Prescalar      => PCLK2_Div_2,
             DMA_Mode       => Disabled,
             Sampling_Delay => Sampling_Delay_5_Cycles);

        Configure_Unit
            (ADC_1,
             Resolution  => ADC_Resolution_12_Bits,
             Alignment   => Right_Aligned);

        Configure_Regular_Conversions
            (ADC_1,
             Continuous  => False,
             Trigger     => Software_Triggered,
             Enable_EOC  => True,
             Conversions => All_Regular_Conversions);

        Enable (ADC_1);
    end Configure_ADC;

    procedure Read_ADC
        (Values  : out ADC_Values;
         Success : out Boolean;
         Timeout : in Time_Span) is
    begin
        for I in Values'Range loop
            Start_Conversion (ADC_1);
            Poll_For_Status (ADC_1, Regular_Channel_Conversion_Complete, Success, Timeout);
            if not Success then
                return;
            end if;
            Values (I) := Conversion_Value (ADC_1);
            Clear_Status (ADC_1, Regular_Channel_Conversion_Complete);
        end loop;
    end Read_ADC;

    procedure Initialize is
    begin
        Fan_Speed_GPIO.Configure_Alternate_Function (Fan_Speed_AF);
        Configure_PWM_Timer (Fan_Speed_Timer'Access, 30_000);
        Enable_Clock (Fan_Speed_Timer);
        Fan_Control.Attach_PWM_Channel
            (Fan_Speed_Timer'Access,
             Fan_Speed_Channel, 
             Fan_Speed_GPIO,
             Fan_Speed_AF);
        Fan_Control.Enable_Output;
        -- Set fan to max speed in case we crash during init
        Set_PWM (Fan, 100);

        Beep_GPIO.Configure_Alternate_Function (Beep_AF);
        Configure_PWM_Timer (Beep_Timer'Access, 1_200);
        Enable_Clock (Beep_Timer);
        Beep_Control.Attach_PWM_Channel
            (Beep_Timer'Access,
             Beep_Channel, 
             Beep_GPIO,
             Beep_AF);
        Beep_Control.Enable_Output;
        -- Beep at startup
        Set_PWM (Beep, 50);

        Fan_Sense_GPIO.Configure_Alternate_Function (Fan_Sense_AF);
        Enable_Clock (Fan_Sense_Timer);
        Configure_Channel_Input_PWM (Fan_Sense_Timer,
            Channel     => Fan_Sense_Channel,
            Polarity    => Both_Edges,
            Selection   => Direct_TI,
            Prescaler   => Div2,
            Filter      => 1);

        Configure_ADC;
    end Initialize;

    procedure Get_Temperature
        (T       : out Celsius;
         Success : out Boolean) is
        type Millivolts is new Float;
        Vrefint : constant Millivolts := 1_210.0;
        Vdda    : constant Millivolts := 3_300.0;
        
        Values  : ADC_Values;

        Vref    : Millivolts;
        Vtemp   : Millivolts;

        Tc      : constant Millivolts := 10.0;   -- Temperature coefficient from datasheet (mV/C)
        Vzero   : constant Millivolts := 500.0;  -- Output at zero celsius (mV)
        Timeout : constant Time_Span := Milliseconds (50);
    begin
        Read_ADC (Values, Success, Timeout);
        Vtemp := Millivolts (Values (Temp_Sense_Rank));
        Vref := Millivolts (Values (Vref_Rank));

        -- Scale Vref to Vdda, should be close to (2**12)
        Vref := Vref * (Vdda / Vrefint);
        Vtemp := (Vtemp / Vref) * Vdda;
        T := Celsius ((Vtemp - Vzero) / Tc);
    end Get_Temperature;

    procedure Set_PWM
        (C          : in Channel;
         Duty_Cycle : in Percent) is
    begin
        case C is
            when Fan =>
                Fan_Control.Set_Duty_Cycle (Percentage (Duty_Cycle));
            when Beep =>
                Beep_Control.Set_Duty_Cycle (Percentage (Duty_Cycle));
        end case;
    end Set_PWM;

    procedure Get_RPM (RPM : out Hertz) is
         Counts : UInt32;
    begin
        Counts := Current_Capture_Value (Fan_Sense_Timer, Fan_Sense_Channel);
        RPM := Hertz (Counts) * 60;
    end Get_RPM;
end Platform;
