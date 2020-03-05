with Ada.Text_IO; use Ada.Text_IO;

package body Platform is
    Simulated_Speed : Percent := 0;
    Simulated_Temp  : Celsius := 21.0;

    procedure Initialize is
    begin
        Put_Line ("Initialize");
    end Initialize;

    procedure Get_Temperature
        (T       : out Celsius;
         Success : out Boolean) is
        package CIO is new Float_IO (Celsius);
    begin
        CIO.Default_Aft := 1;
        CIO.Default_Exp := 0;
        CIO.Default_Fore := 3;

        if Simulated_Speed > 0 then
            Simulated_Temp := Simulated_Temp - Celsius (1.0 * (Float (Simulated_Speed) / 100.0));
            if Simulated_Temp < 15.0 then
                Simulated_Temp := 15.0;
            end if;
        else
            Simulated_Temp := Simulated_Temp + 0.5;
        end if;

        T := Simulated_Temp;
        if T >= -40.0 and T <= 125.0 then
            Success := True;
        else
            Success := False;
        end if;

        Put ("Get_Temperature ");
        CIO.Put (T);
        Put_Line ("C");
    end Get_Temperature;

    procedure Set_PWM
        (C          : in Channel;
         Duty_Cycle : in Percent) is
    begin
        if C = Fan then
            Simulated_Speed := Duty_Cycle;
        end if;

        Put_Line ("Set_PWM " & C'Image & Duty_Cycle'Image & "%");
    end Set_PWM;

    procedure Get_RPM (RPM : out Hertz) is
    begin
        RPM := Hertz (3750.0 * (Float (Simulated_Speed) / 100.0));
        Put_Line ("Get_RPM " & RPM'Image & " RPM");
    end Get_RPM;
end Platform;
