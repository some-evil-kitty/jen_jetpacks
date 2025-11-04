#include "script_component.hpp"

params ["_unit"];

[_unit, _unit call FUNC(pid_vertical)] call FUNC(move);
