#include "script_component.hpp"

params ["_unit"];

[
    _unit getVariable QGVAR(pid_verticalAltitude),
    0.7,
    0.3,
    0.8
] call CBA_pid_fnc_setGains;
[
    _unit getVariable QGVAR(pid_verticalSpeed),
    6.0,
    0.25,
    0.0
] call CBA_pid_fnc_setGains;

[_unit getVariable QGVAR(pid_verticalAltitude), 0] call CBA_pid_fnc_setpoint;
[_unit getVariable QGVAR(pid_verticalSpeed), -0.5] call CBA_pid_fnc_setpoint;
