with Simulator.I2C;

package body Platform is
    I2C_1 : aliased Simulator.I2C.Simulator_I2C_Port;

    procedure Initialize is
    begin
        null;
    end Initialize;

    function I2C_Controller return not null HAL.I2C.Any_I2C_Port is
    begin
        return (I2C_1'Access);
    end I2C_Controller;
end Platform;
