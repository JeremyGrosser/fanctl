with Feather_STM32F405.I2C;

package body Platform is
    procedure Initialize is
    begin
        Feather_STM32F405.I2C.Initialize ( 400_000 );
    end Initialize;

    function I2C_Controller return not null HAL.I2C.Any_I2C_Port is
    begin
        return Feather_STM32F405.I2C.Controller;
    end I2C_Controller;
end Platform;
