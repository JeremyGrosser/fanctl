with Ada.Real_Time;     use Ada.Real_Time;
with Ada.Assertions;    use Ada.Assertions;
with Platform;          use Platform;

procedure Test is

    procedure Test_Fan (F : in Hertz; DC : in Percent) is
        Frequency  : Hertz;
        Duty_Cycle : Percent;
        T          : Time := Clock;
    begin
        Set_PWM (Fan, F, DC);
        T := T + Milliseconds (500);
        delay until T;

        Get_PWM (Fan, Frequency, Duty_Cycle);
        Assert (Frequency   = F);
        Assert (Duty_Cycle  = DC);
    end Test_Fan;

    Temperature : Celsius;
begin
    Initialize;

    Get_Temperature (Temperature);

    Test_Fan (1_000, 100);
    Test_Fan (1_000,  75);
    Test_Fan (  500, 100);
    Test_Fan (    0,   0);
end Test;
