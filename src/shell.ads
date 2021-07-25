--
--  Copyright 2021 (C) Jeremy Grosser
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package Shell is
   procedure Evaluate (Line : String);
   procedure Prompt;
   procedure Poll;
end Shell;
