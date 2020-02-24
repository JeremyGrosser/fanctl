package Controller is
    type Celsius is digits 4;
    type Current is digits 4;
    type Duty_Cycle is new Integer range 0 .. 100;
    type Channel is (Fan, Buzzer);

    procedure Initialize;
    procedure Test;

    procedure Read_Sensors (T : out Celsius;
                            I : out Current);
    Timed_Out : exception;

    procedure Set_PWM (C : in Channel;
                       D : in Duty_Cycle);
end Controller;
