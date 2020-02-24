with Ada.Assertions;
with TI_TMP102;
with Feather_STM32F405.I2C;
with HAL.I2C; use HAL.I2C;

package body Controller is
    TMP102_I2C : constant Any_I2C_Port := Feather_STM32F405.I2C.Controller;
    TMP102_Address : constant := 2#10010000#;
    Simulated_Current : Current := 0.0;

    procedure Initialize is
    begin
        Feather_STM32F405.I2C.Initialize ( 400_000 );
        TI_TMP102.Initialize (TMP102_I2C, TMP102_Address);
    end Initialize;

    procedure Read_Sensors (T : out Celsius;
                            I : out Current) is
    begin
        T := Celsius (TI_TMP102.Temperature (TMP102_I2C, TMP102_Address));
        I := Simulated_Current;
    end Read_Sensors;

    procedure Set_PWM (C : in Channel;
                       D : in Duty_Cycle) is
    begin
        if C = Fan and D > 0 then
            Simulated_Current := 0.25;
        else
            Simulated_Current := 0.0;
        end if;
    end Set_PWM;

    procedure Test is
        use Ada.Assertions;
        T : Celsius;
        I : Current;
    begin
        TI_TMP102.Test;

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
