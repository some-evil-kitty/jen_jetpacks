#include "script_component.hpp"

params ["_unit"];

private _target = _unit getVariable [QGVAR(combat_target), objNull];
private _targetPosition = getPosATLVisual _target;

if (CBA_missionTime - (_unit getVariable QGVAR(lastUpdate)) > 15) then {
    private _angle = random 360;
    private _randomDirection = [sin _angle, cos _angle, GVAR(defaultHoverHeight) + random 10];

    private _hoverSpot = _targetPosition vectorAdd (_randomDirection vectorMultiply FLY_COMBAT_RANGE);
    _hoverSpot set [2, 0];

    [_unit, _hoverSpot, _randomDirection select 2] call FUNC(setWaypoint);
    _unit setVariable [QGVAR(lastUpdate), CBA_missionTime];
};

private _direction = (getPosATLVisual _unit) vectorFromTo _targetPosition;
private _angle = acos ([0, 1, 0] vectorCos _direction);
private _pid = _unit getVariable QGVAR(pid_angle);
_pid set [4, _angle];
_unit setVariable [QGVAR(pid_angle), _pid];
_unit setVariable [QGVAR(setRotation), true];

_unit call FUNC(pid_angle);
