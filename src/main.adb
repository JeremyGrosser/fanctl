with RP.Timer; use RP.Timer;
with RP.Device;

with Fixed_PID_Control; use Fixed_PID_Control;
with Units; use Units;
with Board; use Board;

procedure Main is
   PID : PID_Controller :=
      (Kp       => 0.5,
       Ki       => 0.3,
       Kd       => 0.001,
       Dt       => 10.0,
       Setpoint => 0.1500,
       others   => <>);

   Step : Fixed := 0.01;

   procedure Process_Command
      (Cmd : Character)
   is
   begin
      case Cmd is
         when 'P' => PID.Kp := PID.Kp + Step;
         when 'p' => PID.Kp := PID.Kp - Step;
         when 'I' => PID.Ki := PID.Ki + Step;
         when 'i' => PID.Ki := PID.Ki - Step;
         when 'D' => PID.Kd := PID.Kd + Step;
         when 'd' => PID.Kd := PID.Kd - Step;
         when 'S' => PID.Setpoint := PID.Setpoint + Step;
         when 's' => PID.Setpoint := PID.Setpoint - Step;
         when 'T' => PID.Dt := PID.Dt + 1.0;
         when 't' => PID.Dt := PID.Dt - 1.0;
         when 'X' => Step := Step * 10.0;
         when 'x' => Step := Step / 10.0;
         when others =>
            Console.Put_Line ("Unknown command: " & Cmd);
      end case;
   end Process_Command;

   Max_RPM   : Fixed := 10_000.0;
   Output_DC : Duty_Cycle;
   T         : Time;
   TACO      : RPM;
   C         : Character;

   Multiple : constant Fixed := 1.0 / Fixed'Small;
begin
   Board.Initialize;

   T := Clock;

   loop
      TACO := Measure_TACO;

      Console.Put ("TACO=" & TACO'Image & " RPM ");
      if Fixed (TACO) > Max_RPM then
         Console.Put ('^');
         Max_RPM := Fixed (TACO);
      end if;
      PID.Input := Fixed (TACO) / Max_RPM;

      Update (PID);
      if PID.Output < 0.0 then
         PID.Output := 0.0;
      elsif PID.Output > 1.0 then
         PID.Output := 1.0;
      end if;

      Output_DC := Duty_Cycle (PID.Output * Fixed (Duty_Cycle'Last));
      Set_Output (Output_DC);
      Console.Put ("Output_DC= " & Output_DC'Image & " ");

      Console.Put ("Error= " & Integer (PID.Error * Multiple)'Image & " ");

      Console.New_Line;

      if PID.Output > 0.0 and TACO = 0 then
         Console.Put_Line ("Fan not spinning!");
         Beeper.Beep (Length => 100, Frequency => 800, Count => 3);
      end if;

      T := T + Ticks_Per_Second * Time (PID.Dt);
      while Clock < T loop
         Console.Get (C);
         if C in 'A' .. 'z' then
            Process_Command (C);
            Console.Put_Line (C & "");
            declare
               Kp : constant Integer := Integer (PID.Kp * Multiple);
               Ki : constant Integer := Integer (PID.Ki * Multiple);
               Kd : constant Integer := Integer (PID.Kd * Multiple);
               Dt : constant Integer := Integer (PID.Dt);
               Sp : constant Integer := Integer (PID.Setpoint * Multiple);
               Step_I : constant Integer := Integer (Step * Multiple);
            begin
               Console.Put_Line
                  ("Kp=" & Kp'Image &
                   " Ki=" & Ki'Image &
                   " Kd=" & Kd'Image &
                   " Dt=" & Dt'Image &
                   " Sp=" & Sp'Image &
                   " Step=" & Step_I'Image);
            end;
         end if;
      end loop;
   end loop;
end Main;
