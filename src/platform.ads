package Platform is
    type Celsius is digits 4;
    type Percent is new Integer range 0 .. 100;
    type Channel is (Fan);

    procedure Initialize;
    procedure Get_Temperature
        (T : out Celsius);
    procedure Set_PWM
        (C          : in Channel;
         Duty_Cycle : in Percent);
    procedure Get_PWM
        (C          : in Channel;
         Duty_Cycle : out Percent);
end Platform;
