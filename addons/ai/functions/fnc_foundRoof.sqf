#include "script_component.hpp"

params ["_unit"];

private _pos = _unit getVariable [QGVAR(roofPos), [0, 0, 0]];
_pos isNotEqualTo [0, 0, 0]
