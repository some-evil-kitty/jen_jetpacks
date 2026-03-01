#include "script_component.hpp"

params ["_unit"];

private _deltaAngle = [_unit getVariable QGVAR(pid_angle), direction _unit] call CBA_pid_fnc_update;
private _rotateSpeed = _unit getVariable [QGVAR(rotateSpeed), GVAR(defaultRotateSpeed)];

private _clippedRotation = -_rotateSpeed max (_deltaAngle min _rotateSpeed);

private _newDirection = _clippedRotation * diag_deltaTime + direction _unit;
private _currentDir = vectorDir _unit;
_unit setVectorDir [sin _newDirection, cos _newDirection, _currentDir select 2];
