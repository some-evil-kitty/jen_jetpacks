#include "script_component.hpp"

params ["_unit"];

[QGVAR(takeoff), _unit] call CBA_fnc_localEvent;

private _targetPos = ASLtoAGL (_unit getVariable QGVAR(roofPos));

[_unit, _targetPos, _targetPos select 2] call FUNC(setWaypoint);
