#include "script_component.hpp"

params ["_unit"];

if (_unit getVariable [QGVAR(atWaypoint), false]) exitWith {
    _unit call FUNC(atHover)
};

false
