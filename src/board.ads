with Units; use Units;

with RP.Device;
with RP.GPIO;
with RP.PWM;

with Serial_Console;
with Piezo;
with Pico;

package Board is

   procedure Initialize;

   function Measure_TACO
      return RPM;

   function Measure_TEMP
      return Celsius;

   procedure Set_Output
      (DC : Duty_Cycle);

private

   FAN_PWM  : RP.GPIO.GPIO_Point renames Pico.GP2;
   FAN_TACH : RP.GPIO.GPIO_Point renames Pico.GP3;
   Fan      : RP.PWM.PWM_Point := RP.PWM.To_PWM (FAN_PWM);

   UART_TX : RP.GPIO.GPIO_Point renames Pico.GP16;
   UART_RX : RP.GPIO.GPIO_Point renames Pico.GP17;
   Console : Serial_Console.Port (RP.Device.UART_0'Access);

   Beeper : Piezo.Beeper
      (Point_A => Pico.GP18'Access,
       Point_B => null);

   LED : RP.GPIO.GPIO_Point renames Pico.LED;

   procedure Enable_Output;
   procedure Disable_Output;

end Board;
