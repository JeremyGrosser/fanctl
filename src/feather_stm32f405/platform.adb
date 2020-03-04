with STM32.Device;  use STM32.Device;
with STM32.GPIO;    use STM32.GPIO;
with STM32.Timers;  use STM32.Timers;
with STM32.PWM;     use STM32.PWM;
with STM32;         use STM32;
with HAL;           use HAL;
with Feather_STM32F405;

package body Platform is
    --Temp_In     : GPIO_Point renames Feather_STM32F405.A0;
    --Fan_PWM_In  : GPIO_Point renames Feather_STM32F405.A1;
    Fan_PWM_Out : GPIO_Point renames Feather_STM32F405.D5;

    Timer_AF        : constant GPIO_Alternate_Function := GPIO_AF_TIM3_2;
    Selected_Timer  : Timer renames Timer_3;
    Output_Channel  : constant Timer_Channel := Channel_2;
    Fan_Control     : PWM_Modulator;

    procedure Initialize is
    begin
        Configure_PWM_Timer (Selected_Timer'Access, 30_000);
        Fan_Control.Attach_PWM_Channel
            (Selected_Timer'Access,
             Output_Channel, 
             Fan_PWM_Out,
             Timer_AF);

        Fan_Control.Enable_Output;
    end Initialize;

    procedure Get_Temperature
        (T : out Celsius) is
    begin
        T := 0.0;
    end Get_Temperature;

    procedure Set_PWM
        (C          : in Channel;
         Duty_Cycle : in Percent) is
    begin
        if C = Fan then
            Fan_Control.Set_Duty_Cycle (Percentage (Duty_Cycle));
        end if;
    end Set_PWM;

    procedure Get_RPM
        (C          : in Channel;
         RPM        : out Hertz) is
         Fan_Counts : Hertz := 125; -- rising edges per second on sense pin
    begin
        if C = Fan then
            RPM := (Fan_Counts * 60) / 2;
        end if;
    end Get_RPM;
end Platform;
