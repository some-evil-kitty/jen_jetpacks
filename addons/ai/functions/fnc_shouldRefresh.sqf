#include "script_component.hpp"

params ["_unit"];

private _enter = _unit getVariable [QGVAR(enterTime), CBA_missionTime];
(CBA_missionTIme - _enter > 90)
