with HAL; use HAL;
with RP.Device;
with RP; use RP;

package body Piezo is

   procedure Beep
      (This      : Beeper;
       Frequency : Hertz := 440;
       Duration  : Natural := 1_000;
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
      Set_Duty_Cycle (Slice, 0, 0);
      Enable (Slice);

      for I in 1 .. Count loop
         Set_Duty_Cycle (Slice, Half, Half);
         RP.Device.Timer.Delay_Milliseconds (Duration);
         Set_Duty_Cycle (Slice, 0, 0);
         if I /= Count then
            RP.Device.Timer.Delay_Milliseconds (Duration);
         end if;
      end loop;
   end Beep;

end Piezo;
