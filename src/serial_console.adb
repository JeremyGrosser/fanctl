--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL; use HAL;

package body Serial_Console is
   use HAL.UART;

   procedure Put
      (This : in out Port;
       Item : Character)
   is
      Data   : constant UART_Data_8b (1 .. 1) := (1 => UInt8 (Character'Pos (Item)));
      Status : UART_Status;
   begin
      This.UART.Transmit (Data, Status, 0);
      if Status /= Ok then
         raise Console_Error;
      end if;
   end Put;

   procedure Put
      (This : in out Port;
       Item : String)
   is
      Data   : UART_Data_8b (Item'Range);
      Status : UART_Status;
   begin
      for I in Item'Range loop
         Data (I) := UInt8 (Character'Pos (Item (I)));
      end loop;
      This.UART.Transmit (Data, Status, 0);
      if Status /= Ok then
         raise Console_Error;
      end if;
   end Put;

   procedure Put_Line
      (This : in out Port;
       Item : String)
   is
   begin
      This.Put (Item);
      This.New_Line;
   end Put_Line;

   procedure Get
      (This : in out Port;
       Ch   : out Character)
   is
      Data   : UART_Data_8b (1 .. 1);
      Status : UART_Status;
   begin
      This.UART.Receive (Data, Status, 1);
      case Status is
         when Err_Timeout =>
            Ch := ASCII.NUL;
         when Ok =>
            Ch := Character'Val (Integer (Data (1)));
         when others =>
            Ch := ASCII.DLE;
      end case;
   end Get;

   procedure Get
      (This : in out Port;
       Item : out String)
   is
      Data   : UART_Data_8b (Item'Range);
      Status : UART_Status;
   begin
      This.UART.Receive (Data, Status, 0);
      if Status /= Ok then
         raise Console_Error;
      end if;
      for I in Item'Range loop
         Item (I) := Character'Val (Integer (Data (I)));
      end loop;
   end Get;

   procedure New_Line
      (This : in out Port)
   is
   begin
      This.Put (ASCII.CR & ASCII.LF);
   end New_Line;

   function Get_Line
      (This : in out Port;
       Echo : Boolean := False)
      return String
   is
      Ch : Character;
      I  : Positive := This.Buffer'First;
   begin
      while I <= This.Buffer'Last loop
         Get (This, Ch);
         if Echo then
            This.Put (Ch);
         end if;
         case Ch is
            when ASCII.CR | ASCII.LF =>
               This.New_Line;
               return This.Buffer (This.Buffer'First .. I - 1);
            when ASCII.DEL =>
               This.Put (ASCII.BS & " " & ASCII.BS);
               if I > This.Buffer'First then
                  I := I - 1;
               end if;
            when others =>
               This.Buffer (I) := Ch;
               I := I + 1;
         end case;
      end loop;
      --  Buffer is full but no LF was seen, return the whole thing.
      return This.Buffer;
   end Get_Line;

   function Has_Data
      (This : in out Port)
      return Boolean
   is
      use RP.UART;
   begin
      case This.UART.Receive_Status is
         when Empty | Invalid =>
            return False;
         when others =>
            return True;
      end case;
   end Has_Data;

end Serial_Console;
