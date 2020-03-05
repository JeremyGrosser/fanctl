with Ada.Real_Time;     use Ada.Real_Time;
with Ada.Assertions;    use Ada.Assertions;
with Platform;          use Platform;

procedure Test is
    function In_Range
        (Value : in Float;
         Target : in Float;
         Margin : in Float)
         return Boolean is
    begin
        return (Value >= (Target * (1.0 - Margin))) and
               (Value <= (Target * (1.0 + Margin)));
    end In_Range;

    procedure Test_Fan (DC : in Percent) is
        RPM          : Hertz;
        Expected_RPM : constant Hertz := Hertz (3750.0 * (Float (DC) / 100.0));
        T            : Time := Clock;
    begin
        Set_PWM (Fan, DC);
        T := T + Milliseconds (500);
        delay until T;

        Get_RPM (RPM);
        Assert (In_Range (Float (RPM), Float (Expected_RPM), 0.10));
    end Test_Fan;

    Temperature : Celsius;
    Success     : Boolean;
begin
    Initialize;

    Get_Temperature (Temperature, Success);
    Assert (Success = True);

    Set_PWM (Buzzer, 90);
    Test_Fan (100);

    Set_PWM (Buzzer, 75);
    Test_Fan (75);

    Set_PWM (Buzzer, 50);
    Test_Fan (50);

    Set_PWM (Buzzer, 0);
    Test_Fan (0);
end Test;
