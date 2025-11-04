#include "script_component.hpp"

params ["_unit"];

_unit setVariable [QGVAR(combat_target), _unit call FUNC(bestTarget)];
_unit setVariable [QGVAR(enterTime), CBA_missionTime];
