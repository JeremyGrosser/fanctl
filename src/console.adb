--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL;
with HAL.UART; use HAL.UART;
with RP.UART; use RP.UART;
with RP.Device;
with RP.GPIO;
with Pico;

package body Console is

   Port : RP.UART.UART_Port renames RP.Device.UART_0;
   CRLF : constant String := ASCII.CR & ASCII.LF;

   procedure Initialize is
      use RP.GPIO;

      Console_Config : constant UART_Configuration :=
         (Baud   => 115_200,
          others => <>);
   begin
      Pico.GP16.Configure (Output, Floating, RP.GPIO.UART);
      Pico.GP17.Configure (Output, Floating, RP.GPIO.UART);
      Port.Configure (Console_Config);
   end Initialize;

   procedure New_Line is
   begin
      Put (CRLF);
   end New_Line;

   procedure Put_Line (S : String) is
   begin
      Put (S);
      New_Line;
   end Put_Line;

   procedure Put (S : String) is
   begin
      for C of S loop
         Put (C);
      end loop;
   end Put;

   procedure Put (C : Character) is
      use HAL;
      Data   : constant UART_Data_8b (1 .. 1) := (1 => UInt8 (Character'Pos (C)));
      Status : UART_Status;
   begin
      Port.Transmit (Data, Status);
   end Put;

   function Get return Character is
      Data   : UART_Data_8b (1 .. 1);
      Status : UART_Status;
   begin
      Port.Receive (Data, Status, Timeout => 1);
      case Status is
         when Err_Timeout =>
            return ASCII.NUL;
         when Err_Error =>
            return ASCII.NAK;
         when Busy =>
            return ASCII.DLE;
         when Ok =>
            return Character'Val (Data (1));
      end case;
   end Get;

   procedure Clear is
   begin
      Put (ASCII.ESC & "[2J" & ASCII.ESC & "[H");
   end Clear;
end Console;
