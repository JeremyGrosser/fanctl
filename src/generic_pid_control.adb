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
      This.Integral := This.Integral + Error * This.Dt;
      Derivative := (Error - This.Error) / This.Dt;
      Output := This.Kp * Proportional + This.Ki * This.Integral + This.Kd * Derivative;
      This.Error := Error;
      return Output;
   end Update;

end Generic_PID_Control;
