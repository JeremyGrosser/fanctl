package Controller is
    type Temperature is new Float;
    type Duty_Cycle is new Integer range 0 .. 100;
    type Current is new Float;
    type Channel is (Fan, Buzzer);

    procedure Read_Temperature (T : out Temperature);
    procedure Read_Current (I : out Current);
    procedure Set_PWM (C : in Channel;
                       D : in Duty_Cycle);

    procedure Test;
end Controller;
