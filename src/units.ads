package Units is
   type Fixed is delta 0.001 digits 6;
   subtype RPM is Natural;
   subtype Duty_Cycle is Natural range 0 .. 10;
   type Celsius is digits 4 range -40.0 .. 125.0;
end Units;
