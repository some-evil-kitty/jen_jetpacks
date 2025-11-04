#include "script_component.hpp"

params ["_unit"];

private _command = _unit call FUNC(pid_vertical);
[_unit, _command] call FUNC(move);
