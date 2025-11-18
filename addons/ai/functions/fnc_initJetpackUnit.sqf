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
_unit setUnitPos "UP";

_unit addEventHandler ["AnimChanged", {
	params ["_unit", "_anim"];
    if !(_unit call EFUNC(core,hasJetpack)) exitWith {};
    if (stance _unit isNotEqualTo "STAND") then {
        _unit playActionNow "PlayerStand";
    };
}];

if !(isNil "lambs_danger_fnc_setdisableai") then {
	[[_unit],0] call lambs_danger_fnc_setdisableai;
};

[_unit,true] call ace_headless_fnc_blacklist;

GVAR(jetpackUnits) pushBack _unit;

