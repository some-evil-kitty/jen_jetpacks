#include "script_component.hpp"

params ["_unit"];

if !(_unit call FUNC(enabled)) exitWith {};

private _command = _unit call FUNC(pid_vertical);
[_unit, _command] call FUNC(move);
