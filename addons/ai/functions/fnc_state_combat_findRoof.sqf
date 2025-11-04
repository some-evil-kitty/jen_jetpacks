#include "script_component.hpp"

params ["_unit"];
private _target = _unit getVariable [QGVAR(combat_target), objNull];
if (isNull _target) exitWith {};

private _nearBuildings = _target nearObjects ["House", ROOF_COMBAT_RANGE];
private _raycastsToDo = [];
{
    (boundingBoxReal [_x, "Geometry"]) params ["_min", "_max", "_radius"];
    private _potential = (getPosASLVisual _x) vectorAdd [0, 0, _radius];
    _raycastsToDo pushBack [_potential, getPosASLVisual _target, _target, objNull, false, 1, "FIRE"];
} forEach _nearBuildings;

private _hits = lineIntersectsSurfaces [_raycastsToDo];
private _idx = 0;
_hits = _hits apply {
    private _thisIdx = _idx;
    _idx = _idx + 1;
    if (_x isEqualTo []) then {
        _thisIdx
    } else {
        -1
    }
};

_idx = 0;
private _potentialHouses = _raycastsToDo apply { _x select 0 } select { 
    private _useThis = (_hits select _idx) >= 0;
    _idx = _idx + 1;
    _useThis
};

if (_potentialHouses isEqualTo []) exitWith {
    _unit setVariable [QGVAR(roofPos), [0, 0, 0]];
};

_unit setVariable [QGVAR(roofPos), selectRandom _potentialHouses];
