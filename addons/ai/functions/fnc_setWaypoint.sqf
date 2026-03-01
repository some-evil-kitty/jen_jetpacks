#include "script_component.hpp"

params [["_unit", objNull, [objNull]], ["_waypoint", [0, 0, 0], [[]], 3], ["_hoverAltitude", GVAR(defaultHoverHeight), [0]]];

_unit setVariable [QGVAR(atWaypoint), false];
_unit setVariable [QGVAR(waypoint), _waypoint];
_unit setVariable [QGVAR(hoverHeight), _hoverAltitude];

if !(_unit isNil QGVAR(pid_verticalAltitude)) then {
    [_unit getVariable QGVAR(pid_verticalAltitude), _hoverAltitude] call CBA_pid_fnc_setpoint;
};

if !(_unit call FUNC(inAir)) then {
    [QGVAR(takeoff), _unit] call CBA_fnc_localEvent;
};

