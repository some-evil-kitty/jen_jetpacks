#include "script_component.hpp"

params ["_unit"];

private _assigned = assignedTarget _unit;
if !(isNull _assigned) exitWith {
    _assigned
};

private _firing = getAttackTarget _unit;
if !(isNull _firing) exitWith {
    _firing
};

private _allTargets = _unit targets [true, CONTACT_MAX_DISTANCE];
private _bestDistance = 1e38;
private _bestTarget = objNull;
{
    private _distance = _unit distance _x;
    if (_distance < _bestDistance) then {
        _bestDistance = _distance;
        _bestTarget = _x;
    };
} forEach _allTargets;
_bestTarget
