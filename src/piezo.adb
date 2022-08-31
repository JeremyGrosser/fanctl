--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with RP.Device;
with RP.PWM;
with RP; use RP;

package body Piezo is

   procedure Beep
      (This      : Beeper;
       Frequency : Hertz := 440;
       Length    : Milliseconds := 1_000;
       Count     : Positive := 1)
   is
      use RP.GPIO;
      use RP.PWM;
      Slice  : constant PWM_Slice := To_PWM (This.Point.all).Slice;
      Period : constant := 10_000;
      Half   : constant := Period / 2;
   begin
      Configure (This.Point.all, Output, Floating, RP.GPIO.PWM);

      Set_Mode (Slice, Free_Running);
      Set_Frequency (Slice, Frequency * Period);
      Set_Interval (Slice, Period);
      Set_Duty_Cycle (Slice, Channel_A => 0, Channel_B => 0);
      Enable (Slice);

      for I in 1 .. Count loop
         Set_Duty_Cycle (Slice, Channel_A => Half, Channel_B => Half);
         RP.Device.Timer.Delay_Milliseconds (Length);
         Set_Duty_Cycle (Slice, Channel_A => 0, Channel_B => 0);
         if I /= Count then
            RP.Device.Timer.Delay_Milliseconds (Length);
         end if;
      end loop;
   end Beep;

end Piezo;
