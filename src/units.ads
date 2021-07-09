package Units is
   subtype RPM is Natural range 0 .. 2000;
   subtype Duty_Cycle is Natural range 0 .. 100;
   type Celsius is digits 4 range -40.0 .. 125.0;
end Units;
