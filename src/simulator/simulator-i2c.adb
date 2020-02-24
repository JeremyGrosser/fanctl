with Ada.Text_IO; use Ada.Text_IO;

package body Simulator.I2C is
    overriding
    procedure Master_Transmit (
        This    : in out Simulator_I2C_Port;
        Addr    : I2C_Address;
        Data    : I2C_Data;
        Status  : out I2C_Status;
        Timeout : Natural := 1000) is
    begin
        Status := Ok;

        Put ("I2C Transmit " & Addr'Image & " -> ");
        for I in Data'Range loop
            Put (Data (I)'Image);
        end loop;
        Put_Line ("");
    end Master_Transmit;

    overriding 
    procedure Master_Receive (
        This    : in out Simulator_I2C_Port;
        Addr    : I2C_Address;
        Data    : out I2C_Data;
        Status  : out I2C_Status;
        Timeout : Natural := 1000) is
    begin
        Data (Data'First) := 0;
        Status := Ok;

        Put_Line ("I2C Receive " & Addr'Image);
    end Master_Receive;

    overriding
    procedure Mem_Write (
        This            : in out Simulator_I2C_Port;
        Addr            : I2C_Address;
        Mem_Addr        : UInt16;
        Mem_Addr_Size   : I2C_Memory_Address_Size;
        Data            : I2C_Data;
        Status          : out I2C_Status;
        Timeout         : Natural := 1000) is
    begin
        Status := Ok;

        Put ("I2C Write " & Addr'Image & " [" & Mem_Addr'Image & "] ");
        for I in Data'Range loop
            Put (Data (I)'Image);
        end loop;
        Put_Line ("");
    end Mem_Write;

    overriding
    procedure Mem_Read (
        This            : in out Simulator_I2C_Port;
        Addr            : I2C_Address;
        Mem_Addr        : UInt16;
        Mem_Addr_Size   : I2C_Memory_Address_Size;
        Data            : out I2C_Data;
        Status          : out I2C_Status;
        Timeout         : Natural := 1000) is
    begin
        Data (Data'First) := 0;
        Status := Ok;

        Put ("I2C Read  " & Addr'Image & " [" & Mem_Addr'Image & "] ");
        for I in Data'Range loop
            Put (Data (I)'Image);
        end loop;
        Put_Line ("");
    end Mem_Read;
end Simulator.I2C;
