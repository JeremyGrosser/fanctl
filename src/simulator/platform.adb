with Ada.Text_IO; use Ada.Text_IO;

package body Platform is
    Fan_Duty_Cycle : Percent := 0;

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
         Duty_Cycle : in Percent) is
    begin
        if C = Fan then
            Fan_Duty_Cycle := Duty_Cycle;
        end if;

        Put_Line ("Set_PWM " & C'Image & Duty_Cycle'Image & "%");
    end Set_PWM;

    procedure Get_RPM
        (C          : in Channel;
         RPM        : out Hertz) is
    begin
        RPM := Hertz (3750.0 * (Float (Fan_Duty_Cycle) / 100.0));
        Put_Line ("Get_RPM " & C'Image & RPM'Image & " RPM");
    end Get_RPM;
end Platform;
