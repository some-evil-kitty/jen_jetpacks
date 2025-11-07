#include "script_component.hpp"

params ["_unit"];

_unit getVariable [QGVAR(combat_enabled), false] && (_unit != jen_player)
