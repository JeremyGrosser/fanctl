with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Ada.Assertions;

package body Controller is
    RNG : Generator;

    procedure Read_Temperature (T : out Temperature) is
        package IO is new Float_IO (Temperature);
    begin
        T := Temperature (Random (RNG) * 100.0);
        Put("Temperature = ");
        IO.Put (T, 3, 2, 0);
        Put_Line ("");
    end Read_Temperature;

    procedure Read_Current (I : out Current) is
        package IO is new Float_IO (Current);
    begin
        I := Current (Random (RNG));
        Put("Current = ");
        IO.Put (I, 3, 2, 0);
        Put_Line ("");
    end Read_Current;

    procedure Set_PWM (C : in Channel;
                       D : in Duty_Cycle) is
    begin
        Put_Line (C'Image & " = " & D'Image);
    end Set_PWM;

    procedure Test is
        use Ada.Assertions;
        T : Temperature;
        I : Current;
    begin
        Set_PWM (Fan, 0);
        Set_PWM (Buzzer, 0);

        Read_Temperature (T);
        Read_Current (I);
        if I /= 0.0 then
            raise Assertion_Error;
        end if;
        Set_PWM (Fan, 10);
        Read_Current (I);
        if I = 0.0 then
            raise Assertion_Error;
        end if;
        Set_PWM (Fan, 100);
        Read_Current (I);
        if I = 0.0 then
            raise Assertion_Error;
        end if;

        Set_PWM (Buzzer, 0);
        Set_PWM (Buzzer, 50);
        Set_PWM (Buzzer, 100);

        Set_PWM (Buzzer, 0);
        Set_PWM (Fan, 0);
        Read_Current (I);
        if I /= 0.0 then
            raise Assertion_Error;
        end if;
    end Test;
end Controller;
