#include "script_component.hpp"

params ["_unit"];

_unit call FUNC(pid_vertical);
_unit call FUNC(pid_horizontal);

private _direction = velocity _unit;
_direction set [2, 0];

private _angle = acos ([0, 1, 0] vectorCos _direction);

private _pid = _unit getVariable QGVAR(pid_angle);
_pid set [4, _angle];
_unit setVariable [QGVAR(pid_angle), _pid];

_unit call FUNC(pid_angle);
