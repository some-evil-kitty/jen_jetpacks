#include "script_component.hpp"

params ["_unit"];

private _a = _unit getVariable [QEGVAR(core,acceleration), 0];
private _commandedAcceleration = _unit call FUNC(pid_vertical_altitude);
_commandedAcceleration = _commandedAcceleration + (_unit call FUNC(pid_vertical_speed));

[0, 0, _commandedAcceleration]
