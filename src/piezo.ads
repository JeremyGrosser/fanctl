with RP.GPIO;
with RP.PWM;
with RP;

package Piezo is

   type Beeper (Point : not null access RP.GPIO.GPIO_Point) is tagged null record;

   --  Timer and PWM must be initialized before this.
   procedure Beep
      (This      : Beeper;
       Frequency : RP.Hertz := 440;
       Duration  : Natural := 1_000;
       Count     : Positive := 1);

end Piezo;
