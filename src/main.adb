with RP.Timer; use RP.Timer;
with RP.Device;

with Fixed_PID_Control; use Fixed_PID_Control;
with Units; use Units;
with Board; use Board;
with Text_Format;

procedure Main is
   PID : PID_Controller :=
      (Kp       => 0.3,
       Ki       => 0.2,
       Kd       => Fixed'Small,
       Dt       => 1.0,
       Setpoint => 0.5,
       others   => <>);

   Max_RPM   : constant RPM := 1600;
   Fan_Speed : Fixed; -- scaled to range 0.0 .. 1.0
   Output    : Fixed;
   T         : Time := Clock;
begin
   loop
      Fan_Speed := Fixed (Measure_TACO) / Fixed (Max_RPM);
      Output := PID.Update (Fan_Speed);
      Set_Output (Duty_Cycle (Output * Fixed (Duty_Cycle'Last)));

      Console.Put ("Fan_Speed=" & Text_Format.To_String (Float (Fan_Speed)) & " ");
      Console.Put (" Output=" & Text_Format.To_String (Float (Output)) & " ");
      Console.New_Line;

      --  T := T + Ticks_Per_Second * PID.Dt;
      T := T + Ticks_Per_Second;
      RP.Device.Timer.Delay_Until (T);
   end loop;
end Main;
