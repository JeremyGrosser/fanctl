package Platform is
    subtype Celsius is Float digits 4;
    type Hertz is new Natural;
    subtype Percent is Integer range -100 .. 100;
    type Channel is (Fan, Buzzer);

    procedure Initialize;
    procedure Get_Temperature
        (T          : out Celsius;
         Success    : out Boolean);
    procedure Set_PWM
        (C          : in Channel;
         Duty_Cycle : in Percent);
    procedure Get_RPM (RPM : out Hertz);
end Platform;
