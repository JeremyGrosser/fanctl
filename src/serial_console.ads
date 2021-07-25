--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.UART;
with RP.UART;

package Serial_Console is

   type Port
      (UART : not null access RP.UART.UART_Port)
   is tagged private;

   Console_Error : exception;

   procedure Put
      (This : in out Port;
       Item : Character);

   procedure Put
      (This : in out Port;
       Item : String);

   procedure Put_Line
      (This : in out Port;
       Item : String);

   procedure Get
      (This : in out Port;
       Ch   : out Character);

   procedure Get
      (This : in out Port;
       Item : out String);

   procedure New_Line
      (This : in out Port);

   function Get_Line
      (This : in out Port;
       Echo : Boolean := False)
      return String;

   function Has_Data
      (This : in out Port)
      return Boolean;

private

   type Port
      (UART : not null access RP.UART.UART_Port)
   is tagged record
      Buffer : String (1 .. 64);
   end record;

end Serial_Console;
