#include "script_component.hpp"

params ["_unit"];

_unit setVariable [QGVAR(atWaypoint), false];
_unit setVariable [QGVAR(waypoint), [0, 0, 0]];
