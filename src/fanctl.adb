with Controller; use Controller;
with Ada.Calendar; use Ada.Calendar;

procedure Fanctl is
    Temperature_Threshold : constant Temperature := 50.0;
    Interval : constant Duration := Duration (1.0);
    T : Temperature;
    I : Current;
begin
    Test;

    loop
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
        delay Interval;
    end loop;
end Fanctl;
