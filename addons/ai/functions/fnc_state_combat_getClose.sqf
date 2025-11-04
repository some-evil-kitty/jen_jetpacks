#include "script_component.hpp"

params ["_unit"];

private _target = _unit getVariable [QGVAR(combat_target), objNull];
private _targetPosition = getPosATLVisual _target;

[_unit, _targetPosition] call FUNC(setWaypoint);
