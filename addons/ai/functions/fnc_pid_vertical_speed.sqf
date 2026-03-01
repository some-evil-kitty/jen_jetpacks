#include "script_component.hpp"

params ["_unit"];

[_unit getVariable QGVAR(pid_verticalSpeed), (velocity _unit) select 2] call CBA_pid_fnc_update
