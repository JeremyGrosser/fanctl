with HAL.I2C; use HAL.I2C;
with HAL; use HAL;

package Native.I2C is
    type Native_I2C_Port is limited new I2C_Port with record
        Id : Positive;
    end record;

    overriding
    procedure Master_Transmit (
        This    : in out Native_I2C_Port;
        Addr    : I2C_Address;
        Data    : I2C_Data;
        Status  : out I2C_Status;
        Timeout : Natural := 1000);

    overriding 
    procedure Master_Receive (
        This    : in out Native_I2C_Port;
        Addr    : I2C_Address;
        Data    : out I2C_Data;
        Status  : out I2C_Status;
        Timeout : Natural := 1000);

    overriding
    procedure Mem_Write (
        This            : in out Native_I2C_Port;
        Addr            : I2C_Address;
        Mem_Addr        : UInt16;
        Mem_Addr_Size   : I2C_Memory_Address_Size;
        Data            : I2C_Data;
        Status          : out I2C_Status;
        Timeout         : Natural := 1000);

    overriding
    procedure Mem_Read (
        This            : in out Native_I2C_Port;
        Addr            : I2C_Address;
        Mem_Addr        : UInt16;
        Mem_Addr_Size   : I2C_Memory_Address_Size;
        Data            : out I2C_Data;
        Status          : out I2C_Status;
        Timeout         : Natural := 1000);
end Native.I2C;
