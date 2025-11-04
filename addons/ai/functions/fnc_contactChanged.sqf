#include "script_component.hpp"

params ["_unit"];

private _currentTarget = _unit getVariable [QGVAR(combat_target), objNull];
if !(alive _currentTarget) exitWith {
    true
};

_currentTarget isNotEqualTo (_unit call FUNC(bestTarget))
