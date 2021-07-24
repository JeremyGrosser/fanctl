with Generic_PID_Control;
with Text_Format;
with Units; use Units;
with Board; use Board;

package body Controller is

   package Fixed_PID_Control is new Generic_PID_Control (Units.Fixed);
   use Fixed_PID_Control;

   PID : PID_Controller;

   procedure Initialize is
   begin
      PID.Kp := 0.3;
      PID.Ki := 0.2;
      PID.Kd := Fixed'Small;
      PID.Setpoint := 0.5;
   end Initialize;

   procedure Run is
      Fan_Speed   : Fixed; -- scaled to a value in the range 0.0 .. 1.0
      Output      : Fixed;
   begin
      loop
         Fan_Speed := Fixed (Measure_TACO) / Fixed (Max_RPM);
         Output := PID.Update (Fan_Speed);
         Set_Output (Duty_Cycle (Output * Fixed (Duty_Cycle'Last)));

         Console.Put ("Fan_Speed=" & Text_Format.To_String (Float (Fan_Speed)) & " ");
         Console.Put (" Output=" & Text_Format.To_String (Float (Output)) & " ");
         Console.New_Line;

         PID.Wait;
      end loop;
   end Run;

end Controller;
