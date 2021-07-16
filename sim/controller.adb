with PID_Control; use PID_Control;
with Ada.Text_IO; use Ada.Text_IO;

package body Controller is

   PID    : PID_Controller;
   Input  : Real := 1.0;
   Output : Real := 1.0;

   function Simulate (PV : Real)
      return Real
   is
      Duty_Cycle : Natural;
      RPM        : Natural;
      RV         : Real;
   begin
      Duty_Cycle := Natural (PV * 100.0);
      RPM := Duty_Cycle * 12;
      RPM := RPM - (RPM mod 20) + 100;
      RV := Real (Float (RPM) / 1200.0);
      Put ("RPM=" & RPM'Image);
      Put (" Duty_Cycle=" & Duty_Cycle'Image);
      Put (" RV=" & RV'Image & " ");
      PID.Print;
      New_Line;
      return RV;
   end Simulate;

   procedure Initialize is
   begin
      PID.Dt := 1.0;
      PID.Kp := 0.3;
      PID.Ki := 0.2;
      PID.Kd := Real'Small;
      PID.Setpoint := 0.50;
   end Initialize;

   procedure Update is
   begin
      Input := Simulate (Output);
      Output := PID.Update (Input);
      if Output < 0.0 then
         Output := 0.0;
      elsif Output > 1.0 then
         Output := 1.0;
      end if;

      --PID.Wait;
   end Update;

end Controller;
