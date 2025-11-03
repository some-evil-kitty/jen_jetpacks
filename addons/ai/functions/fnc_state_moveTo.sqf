#include "script_component.hpp"

params ["_unit"];

_unit call FUNC(pid_vertical);
_unit call FUNC(pid_horizontal);