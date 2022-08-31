--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package Units
   with Pure
is
   type Fixed is delta 0.0001 digits 9;
   subtype RPM is Natural;
   subtype Duty_Cycle is Natural range 0 .. 1000;
   type Celsius is digits 4 range -40.0 .. 125.0;
end Units;
