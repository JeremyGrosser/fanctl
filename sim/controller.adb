with PID_Control; use PID_Control;
with Ada.Text_IO; use Ada.Text_IO;

package body Controller is

   PID    : PID_Controller;
   Input  : Real := 0.0;
   Output : Real := 0.0;

   function Simulate (PV : Real)
      return Real
   is
      RV : Real;
   begin
      RV := PV;
      return RV;
   end Simulate;

   procedure Initialize is
   begin
      PID.Dt := 1.0;
      PID.Kp := 0.3;
      PID.Ki := 0.3;
      PID.Kd := Real'Small;
      PID.Setpoint := 0.51;
   end Initialize;

   procedure Update is
      Duty_Cycle : Natural := 0;
      RPM        : Natural := 0;
   begin
      Output := Simulate (Input);
      Input := PID.Update (Output);

      Duty_Cycle := Natural (Output * 100.0);
      RPM := Duty_Cycle * 12;

      Put ("RPM=" & RPM'Image);
      Put (" Duty_Cycle=" & Duty_Cycle'Image & " ");
      PID.Print;
      New_Line;

      --PID.Wait;
   end Update;

end Controller;
