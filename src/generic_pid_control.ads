with RP.Timer; use RP.Timer;

generic
   type Real is delta <> digits <>;
package Generic_PID_Control is

   type PID_State is private;
   type PID_Controller is tagged record
      Dt         : Real := 1.0;
      Setpoint   : Real := 1.0; --  target process value
      Kp         : Real := 0.1;
      Ki         : Real := 0.0;
      Kd         : Real := 0.0;
      State      : PID_State;
   end record;

   function Update
      (This          : in out PID_Controller;
       Process_Value : Real)
       return Real;

   procedure Wait
      (This : in out PID_Controller);

private

   type PID_State is record
      T              : Time := Clock;
      Previous_Error : Real := 0.0;
      Integral       : Real := 0.0;
   end record;

end Generic_PID_Control;
