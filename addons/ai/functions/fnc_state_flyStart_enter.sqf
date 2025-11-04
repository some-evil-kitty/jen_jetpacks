#include "script_component.hpp"

params ["_unit"];

[_unit] call EFUNC(core,doJetpack);

if (_unit isNil QGVAR(waypoint)) then {
    _unit setVariable [QGVAR(waypoint), [0, 0, 0]];
};

// Vertical altitude PID produces a delta-meter result
// This informs us how much we need to move up or down
// From this, we take our achieveable vertical acceleration and generate an acceleration command
// We have bang-bang controls, so either we can fully accelerate up or we fall via gravity
_unit setVariable [QGVAR(pid_verticalAltitude), [
    5.0,                                // p gain
    0.01,                               // i gain
    0.8,                                // d gain
    [],                                 // error history
    _unit getVariable [QGVAR(hoverHeight), GVAR(defaultHoverHeight)]
]];

_unit setVariable [QGVAR(pid_verticalSpeed), [
    3.0,                                // p gain
    0.0,                                // i gain
    1.0,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];

_unit setVariable [QGVAR(pid_horizontal_speed_x), [
    5.0,                                // p gain
    0.02,                               // i gain
    0.8,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];
_unit setVariable [QGVAR(pid_horizontal_speed_y), [
    5.0,                                // p gain
    0.02,                               // i gain
    0.8,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];

_unit setVariable [QGVAR(pid_angle), [
    1.0,                                // p gain
    0.0,                                // i gain
    0.2,                                // d gain
    [],                                 // error history
    0                                   // setpoint
]];
