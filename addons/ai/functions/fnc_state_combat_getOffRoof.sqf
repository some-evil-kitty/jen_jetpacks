#include "script_component.hpp"

params ["_unit"];

private _atPos = _unit getVariable [QGVAR(atWaypoint), false];
if (_atPos && { _unit call FUNC(inAir) }) then {
    [QGVAR(land), _unit] call CBA_fnc_localEvent;
    _unit setVariable [QGVAR(atWaypoint), false];
};
