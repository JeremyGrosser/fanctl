generic
   type Real is delta <> digits <>;
package Generic_PID_Control
   with Pure
is

   type PID_Controller is tagged record
      Dt         : Real := 1.0; --  seconds between calls to Update
      Setpoint   : Real := 1.0; --  target process value
      Kp         : Real := 0.1;
      Ki         : Real := 0.0;
      Kd         : Real := 0.0;

      Error      : Real := 0.0;
      Integral   : Real := 0.0;
   end record;

   function Update
      (This          : in out PID_Controller;
       Process_Value : Real)
       return Real;

end Generic_PID_Control;
