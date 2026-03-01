#include "script_component.hpp"

params ["_unit"];

private _start = getPosASLVisual _unit;
private _end = _start vectorAdd [0, 0, -150];
private _below = lineIntersectsSurfaces [_start, _end, _unit];
private _altitude = (getPosATLVisual _unit) select 2;
if (_below isNotEqualTo []) then {
    _altitude = _start vectorDistance ((_below select 0) select 0);
};

if (GVAR(debug)) then {
    drawLine3D [ASLToAGL _start, ASLToAGL _end, [1, 1, 0, 1], 5];
};

private _deltaAltitude = [_unit getVariable QGVAR(pid_verticalAltitude), _altitude] call CBA_pid_fnc_update;

if (_deltaAltitude == 0) exitWith {0};

private _a = _unit getVariable [QEGVAR(core,acceleration), 0];
private _v0 = (velocity _unit select 2) ^ 2; 
private _radicand = _v0 - 2 * _deltaAltitude * _a;

private _timeToGo = 0;
if (_radicand > 0) then {
    _timeToGo = (_v0 + sqrt _radicand) / (2 * _deltaAltitude);
} else {
    _a = -9.81;
    private _radicand = _v0 - 2 * _deltaAltitude * _a;
    _timeToGo = (_v0 + sqrt _radicand) / (2 * _deltaAltitude);
};

_deltaAltitude / (_timeToGo ^ 2)

