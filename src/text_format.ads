--
--  Copyright (C) 2022 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with HAL.Real_Time_Clock; use HAL.Real_Time_Clock;
with HAL;

package Text_Format is

   function To_String
      (N    : Integer;
       Pad  : Positive := 1;
       Base : Positive := 10)
       return String;

   function To_String
      (Data : HAL.UInt8_Array)
      return String;

   procedure To_Hex
      (Data : HAL.UInt8_Array;
       Hex  : out String);

   function To_Hex
      (Data : HAL.UInt8_Array)
      return String;

   function To_Hex
      (Data : HAL.UInt8)
      return String;

   function To_Bytes
      (S : String)
      return HAL.UInt8_Array;

   function To_String
      (Time        : RTC_Time;
       Date        : RTC_Date;
       Year_Offset : Integer := 2000)
       return String;

   --  Truncates to tenths
   function To_String
      (F : Float)
      return String;

   function To_String
      (F : Long_Float)
      return String;

end Text_Format;
