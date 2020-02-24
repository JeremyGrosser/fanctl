with HAL.I2C;

package Platform is
    procedure Initialize;

    function I2C_Controller return not null HAL.I2C.Any_I2C_Port;
end Platform;
