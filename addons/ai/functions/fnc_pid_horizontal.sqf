#include "script_component.hpp"

params ["_unit"];

private _waypointPosition = _unit getVariable [QGVAR(waypoint), [0, 0, 0]];
if (_waypointPosition isEqualTo [0, 0, 0]) then {
    private _waypoint = (waypoints _unit) select currentWaypoint group _unit;
    _waypointPosition = waypointPosition _waypoint;
};

private _position = getPosASLVisual _unit;
private _velocity = velocity _unit;

private _directionToTarget = _waypointPosition vectorDiff _position;
_directionToTarget set [2, 0];
private _distanceToTarget = vectorMagnitude _directionToTarget;
_directionToTarget = vectorNormalized _directionToTarget;
private _speedInDirection = vectorMagnitude (_directionToTarget vectorMultiply (_velocity vectorDotProduct _directionToTarget));

private _a = _unit getVariable [QEGVAR(core,acceleration), 0];
private _timeToGo = _distanceToTarget / (_speedInDirection + _a);

if (_timeToGo < TTGO_THRESHOLD) exitWith {
    _unit setVariable [QGVAR(atWaypoint), true];
};

private _predictedPosition = _position vectorAdd (_velocity vectorMultiply _timeToGo);

private _zeroEffortMiss =  _predictedPosition vectorDiff _waypointPosition;

private _commandedAccelerationX = ([_unit, _zeroEffortMiss select 0, _timeToGo] call FUNC(pid_horizontal_x));
private _commandedAccelerationY = ([_unit, _zeroEffortMiss select 1, _timeToGo] call FUNC(pid_horizontal_y));

private _relativeCommand = _unit vectorWorldToModelVisual [_commandedAccelerationX, _commandedAccelerationY, 0];

private _ratioX = (_relativeCommand select 0) / _a;
private _ratioY = (_relativeCommand select 1) / _a;

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

_unit setVariable [QEGVAR(core,controlLeft), _moveLeft];
_unit setVariable [QEGVAR(core,controlRight), _moveRight];
_unit setVariable [QEGVAR(core,controlForward), _moveForward];
_unit setVariable [QEGVAR(core,controlBackward), _moveBackward];
