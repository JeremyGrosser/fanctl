with Ada.Real_Time; use Ada.Real_Time;

package PID_Control is

   type Real is delta 0.001 digits 5 range -10.0 .. 10.0;

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

   procedure Print
      (This : in out PID_Controller);

private

   type PID_State is record
      T              : Time := Clock;
      Previous_Error : Real := 0.0;
      Integral       : Real := 0.0;
   end record;

end PID_Control;
