with Units;    use Units;
with RP.Timer; use RP.Timer;
with RP.Device;
with Board;

package body Controller is

   Target_Speed   : constant RPM := 1000;
   Output         : Duty_Cycle := Duty_Cycle'Last / 2;
   Fan_Speed      : RPM;
   T              : Time := Clock;

   procedure Initialize is
   begin
      Board.Initialize;
      Board.Set_Output (Output);
      RP.Device.Timer.Delay_Seconds (1);
   end Initialize;

   procedure Update is
   begin
      Fan_Speed := Board.Measure_TACO;

      if Output > 0 and Fan_Speed = 0 then
         Board.Beeper.Beep
            (Frequency => 800,
             Length    => 25,
             Count     => 5);
      end if;

      if Fan_Speed > Target_Speed and Output > Duty_Cycle'First then
         Output := Output - 1;
      elsif Fan_Speed < Target_Speed and Output < Duty_Cycle'Last then
         Output := Output + 1;
      end if;
      Board.Set_Output (Output);
      Board.Console.Put_Line (Fan_Speed'Image & "," & Output'Image);

      T := T + Milliseconds (10_000);
      RP.Device.Timer.Delay_Until (T);
   end Update;

end Controller;
