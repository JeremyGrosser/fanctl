with RP.GPIO;
with RP;

package Piezo is

   type Beeper (Point : not null access RP.GPIO.GPIO_Point) is tagged null record;

   subtype Milliseconds is Positive;

   --  Timer and PWM must be initialized before this.
   procedure Beep
      (This      : Beeper;
       Frequency : RP.Hertz := 440;
       Length    : Milliseconds := 1_000;
       Count     : Positive := 1);

end Piezo;
