with HAL.I2C;   use HAL.I2C;

package TI_TMP102 is
    subtype Celsius is Float;

    procedure Initialize
        (Port    : not null Any_I2C_Port;
         Address : I2C_Address := 16#90#);
    procedure Test;

    function Temperature
        (Port    : not null Any_I2C_Port;
         Address : I2C_Address := 16#90#) return Celsius;
end TI_TMP102;
