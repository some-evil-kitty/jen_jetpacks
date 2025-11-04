#include "script_component.hpp"

params ["_unit"];

[QGVAR(takeoff), _unit] call CBA_fnc_localEvent;
_unit setUnitPos "UP";

if !(isNil "lambs_danger_fnc_setdisableai") then {
	[[_unit],0] call lambs_danger_fnc_setdisableai;
};

_unit setVariable [QGVAR(lastUpdate), -1e99];
