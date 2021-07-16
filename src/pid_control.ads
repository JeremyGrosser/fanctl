with RP.Timer;

package PID_Control is

   type Real is new Float;

   type PID_State is private;
   type PID_Controller is tagged record
      Dt         : Real := 1.0; --  seconds between updates
      Setpoint   : Real := 1.0; --  target process value
      Kp         : Real := 1.0;
      Ki         : Real := 1.0;
      Kd         : Real := 1.0;
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
      T              : RP.Timer.Time := RP.Timer.Clock;
      Previous_Error : Real := 0.0;
      Integral       : Real := 0.0;
   end record;

end PID_Control;
