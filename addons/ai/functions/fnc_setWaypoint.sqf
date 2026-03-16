#include "script_component.hpp"

params [["_unit", objNull, [objNull]], ["_waypoint", [0, 0, 0], [[]], 3], ["_hoverAltitude", GVAR(defaultHoverHeight), [0]]];

_unit setVariable [QGVAR(atWaypoint), false];
_unit setVariable [QGVAR(waypoint), _waypoint];
_unit setVariable [QGVAR(hoverHeight), _hoverAltitude];

if !(_unit isNil QGVAR(pid_verticalAltitude)) then {
    private _pid = _unit getVariable QGVAR(pid_verticalAltitude);
    _pid set [4, _hoverAltitude];
    _unit setVariable [QGVAR(pid_verticalAltitude), _pid];
};

if !(_unit call FUNC(inAir)) then {
    [QGVAR(takeoff), _unit] call CBA_fnc_localEvent;
};

