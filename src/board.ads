with Units;   use Units;
with RP.Device;

with Serial_Console;
with Piezo;
with Pico;

package Board is

   Beeper  : Piezo.Beeper (Pico.GP18'Access);
   Console : Serial_Console.Port (RP.Device.UART_0'Access);

   procedure Initialize;

   function Measure_TACO
      return RPM;

   function Measure_TEMP
      return Celsius;

   procedure Set_Output
      (DC : Duty_Cycle);

end Board;
