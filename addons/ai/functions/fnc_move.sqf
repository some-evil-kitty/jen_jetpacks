#include "script_component.hpp"

params ["_unit", "_relativeCommand"];

private _a = _unit getVariable [QEGVAR(core,acceleration), 0];

private _ratioX = (_relativeCommand select 0) / _a;
private _ratioY = (_relativeCommand select 1) / _a;
private _ratioZ = (_relativeCommand select 2) / _a;

private _moveLeft = false;
private _moveRight = false;
if (_ratioX > GVAR(defaultFlightTolerance)) then {
    _moveRight = true;
};
if (_ratioX < -GVAR(defaultFlightTolerance)) then {
    _moveLeft = true;
};

private _moveForward = false;
private _moveBackward = false;
if (_ratioY > GVAR(defaultFlightTolerance)) then {
    _moveForward = true;
};
if (_ratioY < -GVAR(defaultFlightTolerance)) then {
    _moveBackward = true;
};

private _moveUp = false;
if (_a > 0) then {
    _moveUp = _ratioZ > (1 - GVAR(defaultHoverTolerance));
} else {
    _moveUp  = _ratioZ < (1 + GVAR(defaultHoverTolerance));
};

_unit setVariable [QEGVAR(core,controlUp), _moveUp];
_unit setVariable [QEGVAR(core,controlLeft), _moveLeft];
_unit setVariable [QEGVAR(core,controlRight), _moveRight];
_unit setVariable [QEGVAR(core,controlForward), _moveForward];
_unit setVariable [QEGVAR(core,controlBackward), _moveBackward];

