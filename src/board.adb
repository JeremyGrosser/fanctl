with HAL; use HAL;
with RP.Timer; use RP.Timer;
with RP;       use RP;
with RP.Clock;
with RP.ADC;
with RP.PWM;

package body Board is

   --  Pin definitions
   UART_TX   : RP.GPIO.GPIO_Point renames Pico.GP16;
   UART_RX   : RP.GPIO.GPIO_Point renames Pico.GP17;

   FAN_PWM   : RP.GPIO.GPIO_Point renames Pico.GP4;
   FAN_TACO  : RP.GPIO.GPIO_Point renames Pico.GP7;

   --  Constants
   TACO_Slice    : constant RP.PWM.PWM_Slice := RP.PWM.To_PWM (FAN_TACO).Slice;
   OUT_Slice     : constant RP.PWM.PWM_Slice := RP.PWM.To_PWM (FAN_PWM).Slice;
   PWM_Frequency : constant := 3_000_000;
   PWM_Interval  : constant := PWM_Frequency / 60; --  nobody's gonna mind some 60 Hz noise.

   --  Runtime variables
   Current_DC    : Duty_Cycle := Duty_Cycle'Last;

   procedure Initialize is
   begin
      RP.Clock.Initialize (Pico.XOSC_Frequency);
      RP.Clock.Enable (RP.Clock.PERI);
      RP.Device.Timer.Enable;
      RP.PWM.Initialize;
      RP.ADC.Enable;

      UART_RX.Configure (Output, Floating, UART);
      UART_TX.Configure (Output, Floating, UART);
      RP.Device.UART_0.Configure (Config => (others => <>));

      FAN_TACO.Configure (Output, Pull_Down, RP.GPIO.PWM, Schmitt => True);
      FAN_PWM.Configure (Output, Pull_Up, RP.GPIO.PWM);
      declare
         use RP.PWM;
      begin
         Set_Mode (TACO_Slice, Rising_Edge);
         Set_Divider (TACO_Slice, 1.0);
         Set_Interval (TACO_Slice, Period'Last);

         Set_Mode (OUT_Slice, Free_Running);
         Set_Frequency (OUT_Slice, PWM_Frequency);
         Set_Interval (OUT_Slice, PWM_Interval);
         Set_Invert (OUT_Slice, True, True);
         Set_Output (Duty_Cycle'Last);
         Enable (OUT_Slice);
      end;

      Beeper.Beep
         (Duration  => 50,
          Frequency => 600);

      Console.New_Line;
      Console.Put_Line ("Ready.");
   end Initialize;

   function Measure_TACO
      return RPM
   is
      use RP.PWM;
      Sample_Time       : constant Positive := 500;
      Saved_DC          : constant Duty_Cycle := Current_DC;
      Pulses_Per_Second : Natural;
   begin
      --  Must not chop the fan's power supply while counting TACO
      Set_Output (Duty_Cycle'Last);

      --  Count rising edges for 500ms
      Set_Count (TACO_Slice, 0);
      Enable (TACO_Slice);
      RP.Device.Timer.Delay_Milliseconds (Sample_Time);
      Pulses_Per_Second := Count (TACO_Slice) * (1_000 / Sample_Time);
      Disable (TACO_Slice);

      --  Restore the duty cycle that was previously set
      Set_Output (Saved_DC);

      --  There are two pulses per revolution, 60 seconds in a minute.
      return RPM ((Pulses_Per_Second / 2) * 60);
   end Measure_TACO;

   function Measure_TEMP
      return Celsius
   is
   begin
      return Celsius (RP.ADC.Temperature);
   end Measure_TEMP;

   procedure Set_Output
      (DC : Duty_Cycle)
   is
      use RP.PWM;
      Conversion : constant Period := (PWM_Interval / Period (Duty_Cycle'Last));
      P          : constant Period := (Period (DC) * Conversion) + 1;
   begin
      Set_Duty_Cycle (OUT_Slice, P, P);
      Current_DC := DC;
   end Set_Output;

end Board;
