#include "script_component.hpp"

params ["_unit"];

private _target = _unit getVariable [QGVAR(combat_target), objNull];
private _targetPosition = getPosATLVisual _target;
private _direction = _targetPosition vectorFromTo getPosATLVisual _unit;

private _hoverSpot = _targetPosition vectorAdd (_direction vectorMultiply CONTACT_MEDIUM_THRESHOLD);

[_unit, _hoverSpot] call FUNC(setWaypoint);
