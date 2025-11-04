#include "script_component.hpp"

params ["_unit"];

private _nearPos = (getPosASLVisual _unit) findEmptyPosition [ROOF_COMBAT_RANGE, ROOF_COMBAT_RANGE, typeOf _unit];
_unit setVariable [QGVAR(floorPos), _nearPos];

[_unit, _nearPos, _unit getVariable QGVAR(hoverHeight)] call FUNC(setWaypoint);
