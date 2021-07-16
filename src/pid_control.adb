with RP.Device;

package body PID_Control is

   function Update
      (This          : in out PID_Controller;
       Process_Value : Real)
      return Real
   is
      Proportional, Integral, Derivative : Real := 0.0;
      Error, Output : Real;
   begin
      Error := This.Setpoint - Process_Value;
      Proportional := Error;
      Integral := Integral + Error * This.Dt;
      Derivative := (Error - This.State.Previous_Error) / This.Dt;
      Output := This.Kp * Proportional + This.Ki * Integral + This.Kd * Derivative;
      This.State.Previous_Error := Error;
      return Output;
   end Update;

   procedure Wait
      (This : in out PID_Controller)
   is
      use RP.Timer;
   begin
      if not RP.Device.Timer.Enabled then
         RP.Device.Timer.Enable;
      end if;
      This.State.T := This.State.T + Time (This.Dt * Real (Ticks_Per_Second));
      RP.Device.Timer.Delay_Until (This.State.T);
   end Wait;

end PID_Control;
