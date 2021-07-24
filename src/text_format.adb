--
--  Copyright 2021 (C) Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
package body Text_Format is

   function To_String
      (N    : Integer;
       Pad  : Positive := 1;
       Base : Positive := 10)
      return String
   is
      Translate : constant String := "0123456789ABCDEF";
      S         : String (1 .. Pad);
      Magnitude : Natural := 1;
      J         : Integer;
   begin
      for I in 1 .. Pad loop
         J := (N / Magnitude) mod Base;
         S (S'Last - (I - 1)) := Translate (Translate'First + J);
         Magnitude := Magnitude * Base;
      end loop;
      if N < 0 then
         return "-" & S;
      else
         return S;
      end if;
   end To_String;

   function To_String
      (Data : HAL.UInt8_Array)
      return String
   is
      S : String (Data'Range);
   begin
      for I in Data'Range loop
         S (I) := Character'Val (Data (I));
      end loop;
      return S;
   end To_String;

   procedure To_Hex
      (Data : HAL.UInt8_Array;
       Hex  : out String)
   is
      I : Integer := Hex'First;
      J : Integer := Data'First;
   begin
      while I < Hex'Last and J < Data'Last loop
         Hex (I .. I + 1) := To_String (Integer (Data (J)), 2, 16);
         Hex (I + 2) := ' ';
         I := I + 3;
         J := J + 1;
      end loop;
      Hex (I .. Hex'Last) := (others => ASCII.NUL);
   end To_Hex;

   function To_Hex
      (Data : HAL.UInt8)
      return String
   is
      S : constant String (1 .. 2) := To_String (Integer (Data), 2, 16);
   begin
      return S;
   end To_Hex;

   function To_Hex
      (Data : HAL.UInt8_Array)
      return String
   is
      S : String (1 .. Data'Length * 3) := (others => ' ');
      Offset : Integer := S'First;
   begin
      for I in Data'Range loop
         S (Offset .. Offset + 1) := To_Hex (Data (I));
         Offset := Offset + 2;
      end loop;
      return S;
   end To_Hex;

   function To_String
      (Time        : RTC_Time;
       Date        : RTC_Date;
       Year_Offset : Integer := 2000)
      return String
   is (To_String (Integer (Date.Year) + Year_Offset, 4)
       & "-"
       & To_String (RTC_Month'Pos (Date.Month) + 1, 2)
       & "-"
       & To_String (Integer (Date.Day), 2)
       & " "
       & To_String (Integer (Time.Hour), 2)
       & ":"
       & To_String (Integer (Time.Min), 2)
       & ":"
       & To_String (Integer (Time.Sec), 2));

   function To_String
      (F : Float)
      return String
   is
      Whole  : constant Integer := Integer (F);
      Tenths : constant Integer := Integer ((F - Float (Whole)) * 10.0) mod 10;
   begin
      return To_String (Whole) & "." & To_String (Tenths);
   end To_String;

   function To_String
      (F : Long_Float)
      return String
   is (To_String (Float (F)));

   function To_Bytes
      (S : String)
      return HAL.UInt8_Array
   is
      use HAL;
      D : UInt8_Array (S'Range);
   begin
      for I in S'Range loop
         D (I) := UInt8 (Character'Pos (S (I)));
      end loop;
      return D;
   end To_Bytes;

end Text_Format;
