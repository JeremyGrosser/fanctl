with PID_Control; use PID_Control;
with Units;       use Units;
with Board;       use Board;

package body Controller is

   PID    : PID_Controller;
   Input  : Real := 0.0;
   Output : Real := 0.0;

   procedure Initialize is
   begin
      PID.Kp := 0.3;
      PID.Ki := 0.2;
      PID.Kd := Real'Small;
      PID.Setpoint := 0.5;
   end Initialize;

   procedure Update is
      Input_RPM : constant RPM := Measure_TACO;
      Output_DC : Duty_Cycle;
   begin
      Input := Real (Float (Input_RPM) / Float (Max_RPM));
      Output := PID.Update (Input);
      Output_DC := Duty_Cycle (Float (Output) * Float (Duty_Cycle'Last));
      Set_Output (Output_DC);

      Console.Put ("RPM=" & Input_RPM'Image);
      Console.Put (" Output_DC=" & Output_DC'Image & " ");
      Console.New_Line;

      PID.Wait;
   end Update;

end Controller;
