#include "script_component.hpp"

params ["_unit"];

if !(local _unit) exitWith {
    [QGVAR(initUnit), _unit, _unit] call CBA_fnc_targetEvent;
};

if (_unit isNil QGVAR(combat_enabled)) then {
    _unit setVariable [QGVAR(combat_enabled), true];
};
_unit setVariable [QGVAR(setRotation), false];
if (_unit isNil QGVAR(hoverHeight)) then {
    _unit setVariable [QGVAR(hoverHeight), GVAR(defaultHoverHeight)];
};
GVAR(jetpackUnits) pushBack _unit;

