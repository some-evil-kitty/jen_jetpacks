#include "script_component.hpp"

params ["_unit"];

[QGVAR(land), _unit] call CBA_fnc_localEvent;
