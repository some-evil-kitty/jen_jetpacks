#include "script_component.hpp"

params ["_unit"];

private _a = _unit getVariable [QEGVAR(core,acceleration), 0];
private _commandedAcceleration = _unit call FUNC(pid_vertical_altitude);
_commandedAcceleration = _commandedAcceleration + (_unit call FUNC(pid_vertical_speed));
private _ratio = _commandedAcceleration / _a;

private _command = false;
if (_a > 0) then {
    _command = _ratio > (1 - GVAR(defaultHoverTolerance));
} else {
    _command = _ratio < (1 + GVAR(defaultHoverTolerance));
};

_unit setVariable [QEGVAR(core,controlUp), _command];
