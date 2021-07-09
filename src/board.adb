with RP; use RP;
with RP.Clock;

package body Board is
   procedure Initialize is
      use RP.GPIO;
   begin
      RP.Clock.Initialize (Pico.XOSC_Frequency);
      RP.Clock.Enable (RP.Clock.PERI);
      RP.Device.Timer.Enable;
      RP.PWM.Initialize;

      LED.Configure (Output, Floating);

      UART_RX.Configure (Output, Floating, UART);
      UART_TX.Configure (Output, Floating, UART);
      RP.Device.UART_0.Configure
         (Config => (Baud => 115_200, others => <>));

      FAN_PWM.Configure (Output, Floating, RP.GPIO.PWM);
      FAN_TACH.Configure (Input, Floating);

      Beeper.Beep
         (Duration  => 50,
          Frequency => 1_000);
   end Initialize;

   procedure Enable_Output is
   begin
      RP.PWM.Enable (Fan.Slice);
   end Enable_Output;

   procedure Disable_Output is
   begin
      RP.PWM.Disable (Fan.Slice);
   end Disable_Output;

   function Measure_TACO
      return RPM
   is
   begin
      Disable_Output;
      --  XXX: TODO
      Enable_Output;
      return 0;
   end Measure_TACO;

   function Measure_TEMP
      return Celsius
   is
   begin
      --  XXX: TODO
      return 30.0;
   end Measure_TEMP;

   procedure Set_Output
      (DC : Duty_Cycle)
   is
   begin
      null;
   end Set_Output;
end Board;
