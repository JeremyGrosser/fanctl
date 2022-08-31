--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
generic
   type Real is delta <> digits <>;
package Generic_PID_Control
   with Pure
is

   type PID_Controller is record
      Kp         : Real := 0.3;
      Ki         : Real := 0.0;
      Kd         : Real := 0.0;
      Dt         : Real := 1.0; --  seconds between calls to Update
      Setpoint   : Real := 1.0; --  target process value
      Input      : Real := 0.0;
      Output     : Real := 0.0;
      Error      : Real := 0.0;
      Integral   : Real := 0.0;
   end record;

   procedure Update
      (This : in out PID_Controller);

end Generic_PID_Control;
