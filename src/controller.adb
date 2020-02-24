with Ada.Assertions;
with STM32.Device; use STM32.Device;

package body Controller is
    procedure Initialize is
    begin
        Enable_Clock (I2C_1);
    end Initialize;

    procedure Read_Sensors (T : out Celsius;
                            I : out Current) is
    begin
        T := 0.0;
        I := 0.0;
    end Read_Sensors;

    procedure Set_PWM (C : in Channel;
                       D : in Duty_Cycle) is
    begin
        null;
    end Set_PWM;

    procedure Test is
        use Ada.Assertions;
        T : Celsius;
        I : Current;
    begin
        Set_PWM (Fan, 0);
        Set_PWM (Buzzer, 0);

        Read_Sensors (T, I);
        if I /= 0.0 then
            raise Assertion_Error;
        end if;
        Set_PWM (Fan, 10);
        Read_Sensors (T, I);
        if I = 0.0 then
            raise Assertion_Error;
        end if;
        Set_PWM (Fan, 100);
        Read_Sensors (T, I);
        if I = 0.0 then
            raise Assertion_Error;
        end if;

        Set_PWM (Buzzer, 0);
        Set_PWM (Buzzer, 50);
        Set_PWM (Buzzer, 100);

        Set_PWM (Buzzer, 0);
        Set_PWM (Fan, 0);
        Read_Sensors (T, I);
        if I /= 0.0 then
            raise Assertion_Error;
        end if;
    end Test;
end Controller;
