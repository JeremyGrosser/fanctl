--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Generic_PID_Control;
with Units;

package Fixed_PID_Control is new Generic_PID_Control (Real => Units.Fixed);
