package Controller is
    type Temperature is new Float;
    type Current is new Float;
    type Duty_Cycle is new Integer range 0 .. 100;
    type Channel is (Fan, Buzzer);

    procedure Read_Sensors (T : out Temperature;
                            I : out Current);
    procedure Set_PWM (C : in Channel;
                       D : in Duty_Cycle);

    procedure Test;
end Controller;
