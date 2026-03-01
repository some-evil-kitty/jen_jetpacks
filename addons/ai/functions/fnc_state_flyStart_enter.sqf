#include "script_component.hpp"
#define BIG_NUMBER 1e10

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
    5.0,
    0.01,
    0.8,
    _unit getVariable [QGVAR(hoverHeight), GVAR(defaultHoverHeight)],
    -BIG_NUMBER,
    +BIG_NUMBER,
    ERROR_HISTORY_LEN 
] call CBA_pid_fnc_create];

_unit setVariable [QGVAR(pid_verticalSpeed), [
    3.0,
    0.0,
    1.0,
    0,
    -BIG_NUMBER,
    +BIG_NUMBER,
    ERROR_HISTORY_LEN
] call CBA_pid_fnc_create];

_unit setVariable [QGVAR(pid_horizontal_speed_x), [
    8.0,
    0.02,
    1.7,
    0,
    -BIG_NUMBER,
    +BIG_NUMBER,
    ERROR_HISTORY_LEN
] call CBA_pid_fnc_create];
_unit setVariable [QGVAR(pid_horizontal_speed_y), [
    8.0,
    0.02,
    1.7,
    0,
    -BIG_NUMBER,
    +BIG_NUMBER,
    ERROR_HISTORY_LEN
] call CBA_pid_fnc_create];

_unit setVariable [QGVAR(pid_angle), [
    1.0,
    0.0,
    0.2,
    0,
    -BIG_NUMBER,
    +BIG_NUMBER,
    ERROR_HISTORY_LEN,
    CBA_pid_fnc_error_degree
] call CBA_pid_fnc_create];
