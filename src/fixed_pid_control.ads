with Generic_PID_Control;
with Units;

package Fixed_PID_Control is new Generic_PID_Control (Real => Units.Fixed);
