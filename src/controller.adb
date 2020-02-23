with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

package body Controller is
    G : Generator;

    procedure Read_Temperature (T : out Temperature) is
        package IO is new Float_IO (Temperature);
    begin
        T := Temperature (Random (G) * 100.0);
        Put("Temperature = ");
        IO.Put (T, 3, 2, 0);
        Put_Line ("");
    end Read_Temperature;

    procedure Read_Current (I : out Current) is
        package IO is new Float_IO (Current);
    begin
        I := Current (Random (G));
        Put("Current = ");
        IO.Put (I, 3, 2, 0);
        Put_Line ("");
    end Read_Current;

    procedure Set_PWM (C : in Channel;
                       D : in Duty_Cycle) is
    begin
        Put_Line (C'Image & " = " & D'Image);
    end Set_PWM;
end Controller;
