#include "script_component.hpp"

params ["_unit"];

[QGVAR(takeoff), _unit] call CBA_fnc_localEvent;
