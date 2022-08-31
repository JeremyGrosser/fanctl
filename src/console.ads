--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package Console is
   procedure Initialize;
   procedure Put (C : Character);
   procedure Put (S : String);
   procedure New_Line;
   procedure Put_Line (S : String);
   function Get return Character;
   procedure Clear;
end Console;
