#include "script_component.hpp"

params ["_unit"];

private _start = (eyePos _unit) vectorAdd [0, 0, -1];
private _flightDirection = velocity _unit;
_flightDirection set [2, 0];
private _testDistance = (3 + 2 * (vectorMagnitude _flightDirection) ^ 2) min 100;
_flightDirection = vectorNormalized _flightDirection;


private _flightNormal = [-(_flightDirection select 1), _flightDirection select 0, _flightDirection select 2];
private _lineTests = [
    [_start, _start vectorAdd (vectorNormalized (_flightDirection vectorAdd (_flightNormal vectorMultiply 0.25)) vectorMultiply _testDistance), _unit, objNull, true, 1, "GEOM"],
    [_start, _start vectorAdd (vectorNormalized (_flightDirection vectorAdd [0, 0, -0.01] vectorAdd (_flightNormal vectorMultiply 0)) vectorMultiply _testDistance), _unit, objNull, true, 1, "GEOM"],
    [_start, _start vectorAdd (vectorNormalized (_flightDirection vectorAdd (_flightNormal vectorMultiply -0.25)) vectorMultiply _testDistance), _unit, objNull, true, 1, "GEOM"],
    [_start, _start vectorAdd (vectorNormalized (_flightDirection vectorAdd [0, 0, 0.5]) vectorMultiply (2 * _testDistance)), _unit, objNull, true, 1, "GEOM"]
];
(lineIntersectsSurfaces [_lineTests]) params ["_rightIntersects", "_centerIntersects", "_leftIntersects", "_upIntersects"];

if (GVAR(debug)) then {
    _lineTests params ["_right", "_center", "_left", "_up"];
    drawLine3D [ASLToAGL (_right select 0), ASLToAGL (_right select 1), [1, 0, 0, 1], 5];
    drawLine3D [ASLToAGL (_center select 0), ASLToAGL (_center select 1), [1, 1, 1, 1], 5];
    drawLine3D [ASLToAGL (_left select 0), ASLToAGL (_left select 1), [0, 0, 1, 1], 5];
    drawLine3D [ASLToAGL (_up select 0), ASLToAGL (_up select 1), [0, 1, 0, 1], 5];
};

// We're gonna fly into something
private _steering = [0, 0, 0];
if (_centerIntersects isNotEqualTo []) then {
    private _mainPressure = (1 - (_start vectorDistance ((_centerIntersects select 0) select 0)) / _testDistance);
    if (_upIntersects isEqualTo []) then {
        _steering = [0, 0, sqrt _mainPressure];
    } else {
        private _leftIntersectPos = (_lineTests select 2) select 1;
        if (_leftIntersects isNotEqualTo []) then {
            _leftIntersectPos = (_leftIntersects select 0) select 0;
        };
        private _rightIntersectPos = (_lineTests select 0) select 1;
        if (_rightIntersects isNotEqualTo []) then {
            _rightIntersectPos = (_rightIntersects select 0) select 0;
        };

        private _leftDistance = _start vectorDistance _leftIntersectPos;
        private _rightDistance = _start vectorDistance _rightIntersectPos;


        if (_leftDistance < _rightDistance) then {
            // turn to the right to avoid
            private _pressure = sqrt abs (1 - _leftDistance / _testDistance);
            _steering = [-_pressure, -(_mainPressure ^ 2), 0];
        } else {
            // turn to the left to avoid
            private _pressure = sqrt abs (1 - _rightDistance / _testDistance);
            _steering = [_pressure, -(_mainPressure ^ 2), 0];
        };
    };

    _steering = _steering vectorMultiply (5 * _testDistance);
};

_steering = _steering vectorAdd (_unit call FUNC(pid_vertical));
_steering = _steering vectorAdd (_unit call FUNC(pid_horizontal));

[_unit, _steering] call FUNC(move);

if !(_unit getVariable [QGVAR(setRotation), false]) then {
    private _direction = velocity _unit;
    _direction set [2, 0];

    private _angle = acos ([0, 1, 0] vectorCos vectorNormalized _direction);

    private _pid = _unit getVariable QGVAR(pid_angle);
    _pid set [4, _angle];
    _unit setVariable [QGVAR(pid_angle), _pid];

    _unit call FUNC(pid_angle);
} else {
    _unit setVariable [QGVAR(setRotation), false];
};
