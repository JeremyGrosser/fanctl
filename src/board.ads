with Units;   use Units;
with RP.Device;

with Console;
with Piezo;
with Pico;

package Board is

   Beeper  : Piezo.Beeper (Pico.GP18'Access);
   Max_RPM : RPM := 1800;

   procedure Initialize;

   function Measure_TACO
      return RPM;

   function Measure_TEMP
      return Celsius;

   procedure Set_Output
      (DC : Duty_Cycle);

end Board;
