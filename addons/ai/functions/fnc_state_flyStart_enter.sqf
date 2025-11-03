#include "script_component.hpp"

params ["_unit"];

[_unit] call EFUNC(core,doJetpack);

_unit setVariable [QGVAR(waypoint), [0, 0, 0]];

// Vertical altitude PID produces a delta-meter result
// This informs us how much we need to move up or down
// From this, we take our achieveable vertical acceleration and generate an acceleration command
// We have bang-bang controls, so either we can fully accelerate up or we fall via gravity
_unit setVariable [QGVAR(pid_verticalAltitude), [
    1.5,                                // p gain
    0.3,                                // i gain
    0.8,                                // d gain
    [],                                 // error history
    GVAR(defaultHoverHeight)            // setpoint
]];

_unit setVariable [QGVAR(pid_verticalSpeed), [
    1.0,                                // p gain
    0.0,                                // i gain
    0.0,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];

_unit setVariable [QGVAR(pid_horizontal_speed_x), [
    3.0,                                // p gain
    0.02,                               // i gain
    0.0,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];
_unit setVariable [QGVAR(pid_horizontal_speed_y), [
    3.0,                                // p gain
    0.02,                               // i gain
    0.0,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];
