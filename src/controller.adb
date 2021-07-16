with PID_Control; use PID_Control;
with Units;    use Units;
with RP.Timer; use RP.Timer;
with RP.Device;
with Board;

package body Controller is

   PID : PID_Controller;

   procedure Initialize is
   begin
      Board.Initialize;
      Board.Set_Output (Duty_Cycle'Last);
      PID.Dt := 1.0;
      PID.Setpoint := 1000.0;
      PID.Wait;
   end Initialize;

   procedure Update is
      Input  : constant Real := Real (Board.Measure_TACO);
      Output : constant Real := PID.Update (Input);
   begin
      Board.Set_Output (Duty_Cycle (Output));
      Board.Console.Put_Line (Integer (Input)'Image & "," & Integer (Output)'Image);
      PID.Wait;
   end Update;

end Controller;
