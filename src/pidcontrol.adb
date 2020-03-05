with Ada.Real_Time;     use Ada.Real_Time;
with Platform;          use Platform;

package body PIDControl is
    Integral : Float := 0.0;

    -- Beep on sensor failure
    procedure Fault_Alarm is
        Duration : constant Time_Span := Milliseconds (25);
        T        : Time := Clock;
    begin
        Set_PWM (Buzzer, 50);
        T := T + Duration;
        delay until T;
        Set_PWM (Buzzer, 0);
        T := T + Duration;
        delay until T;
    end Fault_Alarm;

    function PID (Process_Variable : in Float;
                  Set_Point        : in Float;
                  Dt               : in Float;
                  Previous_Error   : in Float) return Float is
        Kp : constant Float := 1.0;
        Ki : constant Float := 0.01;
        Kd : constant Float := 0.01;
        Error, Derivative : Float;
    begin
        Error := Set_Point - Process_Variable;
        Integral := Integral + (Error * Dt);
        Derivative := (Error - Previous_Error) / Dt;
        return (Kp * Error) + (Ki * Integral) + (Kd * Derivative);
    end PID;

    function Constrain (V, Min, Max : in Integer) return Integer is
    begin
        if V > Max then
            return Max;
        elsif V < Min then
            return Min;
        else
            return V;
        end if;
    end Constrain;

    function Constrain (V, Min, Max : in Float) return Float is
    begin
        if V > Max then
            return Max;
        elsif V < Min then
            return Min;
        else
            return V;
        end if;
    end Constrain;

    procedure Run is
        Dt          : constant Float := 0.1;
        Interval    : constant Time_Span := Milliseconds (Integer (Dt * 1000.0));
        T           : Time := Clock;

        Set_Point   : constant Celsius := 50.0;
        Temperature : Celsius;
        RPM         : Hertz;
        Success     : Boolean;
        Fan_Speed   : Percent := 100;
        Error_F     : Float := 0.0;
        Error_I     : Integer := 0;
        Target      : Integer;
    begin
        Initialize;

        loop
            Get_Temperature (Temperature, Success);
            if Success = False then
                Fault_Alarm;
                Set_PWM (Fan, Percent'Last);
            else
                if Temperature > (Set_Point + 10.0) then
                    Fault_Alarm;
                end if;

                Error_F := PID
                    (Process_Variable => Temperature,
                     Set_Point          => Set_Point,
                     Dt                 => Dt,
                     Previous_Error     => Error_F);

                Error_I := Integer (Constrain (Float'Rounding (Error_F),
                                               Min => Float (Percent'First),
                                               Max => Float (Percent'Last)));

                Target := Fan_Speed - Error_I;
                Target := Constrain (Target, 0, Percent'Last - 1);

                Fan_Speed := Target;
                Set_PWM (Fan, Fan_Speed);

                T := T + Interval;
                delay until T;

                Get_RPM (RPM);
                if Target > 0 and RPM = 0 then
                    Fault_Alarm;
                end if;
            end if;
        end loop;
    end Run;
end PIDControl;
