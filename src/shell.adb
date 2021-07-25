--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Console;
with Pico;

package body Shell is

   subtype Line_Index is Positive range 1 .. 32;
   Line : String (Line_Index) := (others => ASCII.NUL);
   I    : Line_Index := Line'First;

   procedure Prompt is
   begin
      Console.New_Line;
      Console.Put ("fanctl> ");
   end Prompt;

   procedure Evaluate (Line : String) is
   begin
      if Line = "hi" then
         Console.Put_Line ("HELLO PICO");
      elsif Line = "clear" then
         Console.Clear;
      else
         Console.Put_Line ("commands: clear hi");
      end if;

      Prompt;
   end Evaluate;

   procedure Poll is
      C : Character;
   begin
      C := Console.Get;
      case C is
         when ASCII.CR =>
            Console.New_Line;
            Evaluate (Line (Line'First .. I - 1));
            I := Line'First;
         when ASCII.DEL =>
            Console.Put (ASCII.BS);
            Console.Put (' ');
            Console.Put (ASCII.BS);
         when ASCII.NUL =>
            null;
         when others =>
            Console.Put (C);
            Line (I) := C;
            if I = Line'Last then
               I := Line'First;
               Console.Put_Line ("OVERFLOW");
               Console.New_Line;
            else
               I := I + 1;
            end if;
      end case;
      Pico.LED.Toggle;
   end Poll;

end Shell;
