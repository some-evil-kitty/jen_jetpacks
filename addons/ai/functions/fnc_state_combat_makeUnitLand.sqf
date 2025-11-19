#include "script_component.hpp"

params ["_unit"];

if (GVAR(debug)) then {
	systemChat (["Making unit land: ", str _unit] joinString "")
};

[QGVAR(land), _unit] call CBA_fnc_localEvent;
