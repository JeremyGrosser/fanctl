with Ada.Text_IO; use Ada.Text_IO;
with Ada.Assertions;

package body Controller is
    procedure Read_Sensors (T : out Temperature;
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
        T : Temperature;
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
