#include "script_component.hpp"

params ["_unit"];

_unit setVariable [QGVAR(pid_verticalAltitude), [
    1.5,                                // p gain
    0.3,                                // i gain
    0.8,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];

_unit setVariable [QGVAR(pid_verticalSpeed), [
    3.0,                                // p gain
    0.5,                                // i gain
    0.0,                                // d gain
    [],                                 // error history
    -0.7                                // setpoint
]];

