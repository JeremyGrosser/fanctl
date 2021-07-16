with Ada.Text_IO; use Ada.Text_IO;

package body PID_Control is

   function Update
      (This          : in out PID_Controller;
       Process_Value : Real)
      return Real
   is
      Proportional, Derivative : Real := 0.0;
      Error, Output : Real;
   begin
      Error := This.Setpoint - Process_Value;
      Proportional := Error;
      This.State.Integral := This.State.Integral + Error * This.Dt;
      Derivative := (Error - This.State.Previous_Error) / This.Dt;
      Output := This.Kp * Proportional + This.Ki * This.State.Integral + This.Kd * Derivative;
      This.State.Previous_Error := Error;
      return Output;
   end Update;

   procedure Wait
      (This : in out PID_Controller)
   is
   begin
      This.State.T := This.State.T + Milliseconds (Integer (This.Dt * 1000.0));
      delay until This.State.T;
   end Wait;

   procedure Print
      (This : in out PID_Controller)
   is
   begin
      Put ("Error=" & This.State.Previous_Error'Image);
      Put (" Integral=" & This.State.Integral'Image);
   end Print;

end PID_Control;
