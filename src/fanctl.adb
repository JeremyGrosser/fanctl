with Controller; use Controller;
with Ada.Calendar; use Ada.Calendar;

procedure Fanctl is
    Temperature_Threshold : constant Temperature := 50.0;
    T : Temperature;
    I : Current;
begin
    loop
        Read_Temperature (T);
        if T > Temperature_Threshold then
            Set_PWM (Fan, Duty_Cycle'Last);
            Read_Current (I);
            if I = Current'First or I >= 0.9 then
                Set_PWM (Buzzer, Duty_Cycle'Last / 2);
            else
                Set_PWM (Buzzer, Duty_Cycle'First);
            end if;
        else
            Set_PWM (Fan, Duty_Cycle'First);
            Read_Current (I);
            if I /= Current'First then
                Set_PWM (Buzzer, Duty_Cycle'Last / 2);
            else
                Set_PWM (Buzzer, Duty_Cycle'First);
            end if;
        end if;
        delay Duration (1.0);
    end loop;
end Fanctl;
