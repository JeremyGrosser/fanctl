package Platform is
    type Celsius is digits 4;
    type Hertz is new Natural;
    type Percent is new Integer range 0 .. 100;
    type Channel is (Fan, Buzzer);

    procedure Initialize;
    procedure Get_Temperature
        (T          : out Celsius;
         Success    : out Boolean);
    procedure Set_PWM
        (C          : in Channel;
         Duty_Cycle : in Percent);
    procedure Get_RPM
        (C          : in Channel;
         RPM        : out Hertz);
end Platform;
