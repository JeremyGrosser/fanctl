with Board; use Board;
with RP.Device;

package body Generic_PID_Control is

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
      This.State.T := This.State.T + Time (Float (This.Dt) * Float (Ticks_Per_Second));
      if not RP.Device.Timer.Enabled then
         RP.Device.Timer.Enable;
      end if;
      RP.Device.Timer.Delay_Until (This.State.T);
   end Wait;

end Generic_PID_Control;
