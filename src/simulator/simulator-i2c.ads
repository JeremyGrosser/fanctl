with HAL.I2C; use HAL.I2C;
with HAL; use HAL;

package Simulator.I2C is
    type Simulator_I2C_Port is limited new I2C_Port with null record;

    overriding
    procedure Master_Transmit (
        This    : in out Simulator_I2C_Port;
        Addr    : I2C_Address;
        Data    : I2C_Data;
        Status  : out I2C_Status;
        Timeout : Natural := 1000);

    overriding 
    procedure Master_Receive (
        This    : in out Simulator_I2C_Port;
        Addr    : I2C_Address;
        Data    : out I2C_Data;
        Status  : out I2C_Status;
        Timeout : Natural := 1000);

    overriding
    procedure Mem_Write (
        This            : in out Simulator_I2C_Port;
        Addr            : I2C_Address;
        Mem_Addr        : UInt16;
        Mem_Addr_Size   : I2C_Memory_Address_Size;
        Data            : I2C_Data;
        Status          : out I2C_Status;
        Timeout         : Natural := 1000);

    overriding
    procedure Mem_Read (
        This            : in out Simulator_I2C_Port;
        Addr            : I2C_Address;
        Mem_Addr        : UInt16;
        Mem_Addr_Size   : I2C_Memory_Address_Size;
        Data            : out I2C_Data;
        Status          : out I2C_Status;
        Timeout         : Natural := 1000);
end Simulator.I2C;
