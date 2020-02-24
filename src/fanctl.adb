with Controller; use Controller;
with Ada.Real_Time; use Ada.Real_Time;

procedure Fanctl is
    Temperature_Threshold : constant Celsius := 30.0;
    T : Celsius;
    I : Current;

    Next_Second : Time := Clock;
    Interval : constant Time_Span := Milliseconds(100);
begin
    Initialize;
    Test;

    loop
        delay until Next_Second;
        Read_Sensors (T, I);
        if T > Temperature_Threshold then
            Set_PWM (Fan, Duty_Cycle'Last);
            if I = Current'First or I >= 0.9 then
                Set_PWM (Fan, Duty_Cycle'First);
                Set_PWM (Buzzer, Duty_Cycle'Last / 2);
            else
                Set_PWM (Buzzer, Duty_Cycle'First);
            end if;
        else
            Set_PWM (Fan, Duty_Cycle'First);
            if I /= Current'First then
                Set_PWM (Fan, Duty_Cycle'First);
                Set_PWM (Buzzer, Duty_Cycle'Last / 2);
            else
                Set_PWM (Buzzer, Duty_Cycle'First);
            end if;
        end if;

        Next_Second := Next_Second + Interval;
    end loop;
end Fanctl;
