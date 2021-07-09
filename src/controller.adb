with Board;

package body Controller is

   Step        : constant Duty_Cycle := 10;
   Output      : Duty_Cycle := 0;
   Fan_Speed   : RPM;
   Temperature : Celsius := 25.0;

   function Target_Speed
      return RPM
   is
   begin
      if Temperature > 20.0 then
         return RPM'Last;
      else
         return RPM'First;
      end if;
   end Target_Speed;

   procedure Initialize renames Board.Initialize;

   procedure Run is
   begin
      loop
         Fan_Speed := Board.Measure_TACO;
         Temperature := Board.Measure_TEMP;

         if Target_Speed > Fan_Speed then
            Output := Output + Step;
         elsif Target_Speed < Fan_Speed then
            Output := Output - Step;
         end if;
         Board.Set_Output (Output);
      end loop;
   end Run;

end Controller;
