with HAL; use HAL;
with Interfaces; use Interfaces;
with Ada.Assertions;

package body TMP102 is
    -- Datasheet section 7.3.1 conversion algorithm (12-bit mode)
    function Convert (T : Unsigned_16) return Celsius is
        Resolution : constant := 0.0625;
        C : Celsius;
        X : Unsigned_16;
    begin
        if (T and 16#800#) = 0 then
            C := Celsius (T) * Resolution;
        else
            X := ((not T) and 16#7FF#) + 1;
            C := Celsius (X) * (-Resolution);
        end if;

        return C;
    end Convert;

    -- Examples copied from datasheet
    procedure Test is
        use Ada.Assertions;
    begin
        if Convert (16#7FF#) /= Celsius (127.9375)  then raise Assertion_Error; end if;
        if Convert (16#640#) /= Celsius (100.0)     then raise Assertion_Error; end if;
        if Convert (16#500#) /= Celsius (80.0)      then raise Assertion_Error; end if;
        if Convert (16#4B0#) /= Celsius (75.0)      then raise Assertion_Error; end if;
        if Convert (16#320#) /= Celsius (50.0)      then raise Assertion_Error; end if;
        if Convert (16#190#) /= Celsius (25.0)      then raise Assertion_Error; end if;
        if Convert (16#000#) /= Celsius (0.0)       then raise Assertion_Error; end if;
        if Convert (16#FFC#) /= Celsius (-0.25)     then raise Assertion_Error; end if;
        if Convert (16#E70#) /= Celsius (-25.0)     then raise Assertion_Error; end if;
        if Convert (16#C90#) /= Celsius (-55.0)     then raise Assertion_Error; end if;
    end Test;

    -- Ensure that the pointer address register is set to 0
    procedure Initialize
        (Port    : not null Any_I2C_Port;
         Address : I2C_Address := 16#90#) is
         Value   : I2C_Data (1 .. 1);
         Result  : I2C_Status;
    begin
        Value (1) := 0;
        Mem_Write (Port.all, Address,
            Mem_Addr        => 0,
            Mem_Addr_Size   => Memory_Size_8b,
            Data            => Value,
            Status          => Result);

        if Result /= Ok then
           raise Program_Error with "I2C write error:" & Result'Img;
        end if;
    end Initialize;

    function Temperature
        (Port    : not null Any_I2C_Port;
         Address : I2C_Address := 16#90#)
         return Celsius is
         Register   : constant := 16#00#;
         Value      : I2C_Data (1 .. 2) := (0, 0);
         Result     : I2C_Status;
         T          : Unsigned_16;
    begin
        Mem_Read (Port.all, Address,
            Mem_Addr        => Register,
            Mem_Addr_Size   => Memory_Size_8b,
            Data            => Value,
            Status          => Result);

        if Result /= Ok then
           raise Program_Error with "I2C read error:" & Result'Img;
        end if;

        T := Unsigned_16(Value(2));
        T := Shift_Right(T, 4);
        T := T or Shift_Left(Unsigned_16(Value(1)), 4);
        return Convert(T);
    end Temperature;
end TMP102;
