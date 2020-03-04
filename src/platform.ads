package Platform is
    type Celsius is digits 4;
    type Hertz is new Natural;
    type Percent is new Integer range 0 .. 100;
    type Channel is (Fan);

    procedure Initialize;
    procedure Get_Temperature
        (T : out Celsius);
    procedure Set_PWM
        (C          : in Channel;
         Frequency  : in Hertz;
         Duty_Cycle : in Percent);
    procedure Get_PWM
        (C          : in Channel;
         Frequency  : out Hertz;
         Duty_Cycle : out Percent);
end Platform;
