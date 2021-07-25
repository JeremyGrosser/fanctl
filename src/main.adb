with RP.Timer; use RP.Timer;
with RP.Device;

with Fixed_PID_Control; use Fixed_PID_Control;
with Units; use Units;
with Board; use Board;
with Console;
with Shell;

procedure Main is
   PID : PID_Controller :=
      (Kp       => 0.5,
       Ki       => 0.3,
       Kd       => 0.001,
       Dt       => 10.0,
       Setpoint => 0.1500,
       others   => <>);

   Step : Fixed := 0.01;

   Max_RPM   : Fixed := 10_000.0;
   Output_DC : Duty_Cycle;
   T         : Time;
   TACO      : RPM;

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
         --  Beeper.Beep (Length => 100, Frequency => 800, Count => 3);
      end if;

      T := T + Ticks_Per_Second * Time (PID.Dt);
      Shell.Prompt;
      while Clock < T loop
         Shell.Poll;
      end loop;
      Console.New_Line;
   end loop;
end Main;
