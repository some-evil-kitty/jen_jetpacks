#include "script_component.hpp"

params ["_unit"];

if (_unit getVariable [QGVAR(atWaypoint), false]) exitWith {
    false
};

private _waypointCount = count waypoints _unit;
if (currentWaypoint group _unit != _waypointCount) exitWith {
    true
};

if ((_unit getVariable [QGVAR(waypoint), [0, 0, 0]]) isNotEqualTo [0, 0, 0]) exitWith {
    true
};

false
