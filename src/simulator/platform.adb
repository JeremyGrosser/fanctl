with Ada.Text_IO; use Ada.Text_IO;

package body Platform is
    Fan_Duty_Cycle : Percent := 0;
    Fan_Frequency  : Hertz   := 0;

    procedure Initialize is
    begin
        Put_Line ("Initialize");
    end Initialize;

    procedure Get_Temperature
        (T : out Celsius) is
        package CIO is new Float_IO (Celsius);
    begin
        CIO.Default_Aft := 1;
        CIO.Default_Exp := 0;
        CIO.Default_Fore := 3;

        T := 0.0;
        Put ("Get_Temperature ");
        CIO.Put (T);
        Put_Line ("C");
    end Get_Temperature;

    procedure Set_PWM
        (C          : in Channel;
         Frequency  : in Hertz;
         Duty_Cycle : in Percent) is
    begin
        if C = Fan then
            Fan_Duty_Cycle := Duty_Cycle;
            Fan_Frequency  := Frequency;
        end if;

        Put_Line ("Set_PWM " & C'Image & Frequency'Image & "Hz " & Duty_Cycle'Image & "%");
    end Set_PWM;

    procedure Get_PWM
        (C          : in Channel;
         Frequency  : out Hertz;
         Duty_Cycle : out Percent) is
    begin
        Frequency := Fan_Frequency;
        Duty_Cycle := Fan_Duty_Cycle;
        Put_Line ("Get_PWM " & C'Image & Frequency'Image & "Hz " & Duty_Cycle'Image & "%");
    end Get_PWM;
end Platform;
