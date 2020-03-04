with Ada.Real_Time;     use Ada.Real_Time;
with Ada.Assertions;    use Ada.Assertions;
with Platform;          use Platform;

procedure Test is
    procedure Test_Fan (DC : in Percent) is
        Duty_Cycle : Percent;
        T          : Time := Clock;
    begin
        Set_PWM (Fan, DC);
        T := T + Milliseconds (500);
        delay until T;

        Get_PWM (Fan, Duty_Cycle);
        Assert (Duty_Cycle  = DC);
    end Test_Fan;

    Temperature : Celsius;
begin
    Initialize;

    Get_Temperature (Temperature);

    Test_Fan (100);
    Test_Fan (75);
    Test_Fan (50);
    Test_Fan (0);
end Test;
