with Ada.Real_Time; use Ada.Real_Time;
with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;
with STM32.Timers;  use STM32.Timers;
with STM32.PWM;     use STM32.PWM;
with STM32.ADC;     use STM32.ADC;
with STM32;         use STM32;
with HAL;           use HAL;
with Feather_STM32F405;

package body Platform is
    Fan_Speed           : GPIO_Point renames Feather_STM32F405.D5;
    Fan_Speed_AF        : constant GPIO_Alternate_Function := GPIO_AF_TIM3_2;
    Fan_Speed_Timer     : Timer renames Timer_3;
    Fan_Speed_Channel   : constant Timer_Channel := Channel_2;
    Fan_Control         : PWM_Modulator;

    Fan_Sense           : GPIO_Point renames Feather_STM32F405.D6;
    Fan_Sense_AF        : constant GPIO_Alternate_Function := GPIO_AF_TIM8_1;
    Fan_Sense_Timer     : Timer renames Timer_8;
    Fan_Sense_Channel   : constant Timer_Channel := Channel_1;

    Temp_Sense          : GPIO_Point renames Feather_STM32F405.A0;
    Temp_Sense_ADC      : Analog_To_Digital_Converter renames ADC_1;
    Temp_Sense_Channel  : constant Analog_Input_Channel := 4;
    Temp_Sense_Rank     : constant Injected_Channel_Rank := 1;

    VRef_ADC            : Analog_To_Digital_Converter renames ADC_1;
    VRef_Rank           : constant Injected_Channel_Rank := 2;

    procedure Initialize is
    begin
        Configure_PWM_Timer (Fan_Speed_Timer'Access, 30_000);
        Fan_Control.Attach_PWM_Channel
            (Fan_Speed_Timer'Access,
             Fan_Speed_Channel, 
             Fan_Speed,
             Fan_Speed_AF);
        Fan_Control.Enable_Output;
        -- Set fan to max speed in case we crash during init
        Set_PWM (Fan, 100);

        Fan_Sense.Configure_Alternate_Function (Fan_Sense_AF);
        Enable_Clock (Fan_Sense_Timer);
        Configure_Channel_Input_PWM (Fan_Sense_Timer,
            Channel     => Fan_Sense_Channel,
            Polarity    => Both_Edges,
            Selection   => Direct_TI,
            Prescaler   => Div2,
            Filter      => 1);

        Enable_Clock (Temp_Sense_ADC);
        Configure_Unit (Temp_Sense_ADC,
            Resolution  => ADC_Resolution_12_Bits,
            Alignment   => Right_Aligned);
        Configure_Injected_Conversions (Temp_Sense_ADC,
            AutoInjection   => True,
            Trigger         => Software_Triggered_Injected,
            Enable_EOC      => False,
            Conversions     => ((Temp_Sense_Channel, Sample_3_Cycles, 1),
                                (VRef_Channel,       Sample_3_Cycles, 2)));
        Enable (Temp_Sense_ADC);
        Start_Injected_Conversion (Temp_Sense_ADC);
    end Initialize;

    procedure Get_Temperature
        (T       : out Celsius;
         Success : out Boolean) is
        type Millivolts is new Float;
        Tc      : constant Millivolts := 10.0;   -- Temperature coefficient from datasheet (mV/C)
        Vzero   : constant Millivolts := 500.0;  -- Output at zero celsius (mV)
        Timeout : constant Time_Span := Milliseconds (100);
        VTemp, VDiv : Millivolts;
        Sense_Temp, Sense_Ref : UInt16;
    begin
        Start_Injected_Conversion (Temp_Sense_ADC);
        Poll_For_Status (Temp_Sense_ADC, Injected_Channel_Conversion_Complete, Success, Timeout);
        if Success then
            Sense_Temp := Injected_Conversion_Value (Temp_Sense_ADC, Temp_Sense_Rank);
            Sense_Ref  := Injected_Conversion_Value (VRef_ADC, VRef_Rank);
            VDiv := Millivolts (Sense_Ref) / Millivolts (2 ** 12); -- Scale to ADC resolution
            VTemp := Millivolts (Sense_Temp) * VDiv;
            T := Celsius ((VTemp - Vzero) / Tc);
        end if;
    end Get_Temperature;

    procedure Set_PWM
        (C          : in Channel;
         Duty_Cycle : in Percent) is
    begin
        if C = Fan then
            Fan_Control.Set_Duty_Cycle (Percentage (Duty_Cycle));
        end if;
    end Set_PWM;

    procedure Get_RPM (RPM : out Hertz) is
         Counts : UInt32;
    begin
        Counts := Current_Capture_Value (Fan_Sense_Timer, Fan_Sense_Channel);
        RPM := Hertz (Counts) * 60;
    end Get_RPM;
end Platform;
