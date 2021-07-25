package body Generic_PID_Control is

   procedure Update
      (This : in out PID_Controller)
   is
      Proportional : Real;
      Derivative   : Real;
      Error        : Real;
   begin
      Error := This.Setpoint - This.Input;
      Proportional := Error;
      This.Integral := This.Integral + Error * This.Dt;
      Derivative := (Error - This.Error) / This.Dt;
      This.Output := This.Kp * Proportional + This.Ki * This.Integral + This.Kd * Derivative;
      This.Error := Error;
   end Update;

end Generic_PID_Control;
