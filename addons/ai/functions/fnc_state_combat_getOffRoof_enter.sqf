#include "script_component.hpp"

params ["_unit"];

private _nearPos = [];
for "_i" from 0 to 3 do {
    private _distance = (2 ^ _i) * ROOF_COMBAT_RANGE + 0.5 * random ROOF_COMBAT_RANGE;
    _nearPos = (getPosASLVisual _unit) findEmptyPosition [_distance, _distance, typeOf _unit];
    if (_nearPos isNotEqualTo []) then { break };
};
if (_nearPos isEqualTo []) then {
    _nearPos = [0, 0, 0];
};
_unit setVariable [QGVAR(floorPos), _nearPos];

[_unit, _nearPos, _unit getVariable QGVAR(hoverHeight)] call FUNC(setWaypoint);