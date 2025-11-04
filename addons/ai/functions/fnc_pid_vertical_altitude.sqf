#include "script_component.hpp"

params ["_unit"];

private _verticalAltitudePid = _unit getVariable QGVAR(pid_verticalAltitude);
_verticalAltitudePid params ["_pGain", "_iGain", "_dGain", "_errorHistory", "_setpoint"];

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

private _error = _setpoint - _altitude;
_errorHistory pushBack [
    CBA_missionTime,
    _error
];

if (count _errorHistory > ERROR_HISTORY_LEN) then {
    _errorHistory deleteAt 0;
};
private _derivative = 0;
switch (true) do {
    case (count _errorHistory == 2): {
        private _x0 = _errorHistory select 0;
        private _x1 = _errorHistory select 1;

        private _stride = (_x1 select 0) - (_x0 select 0);
        if (_stride == 0) then { break };

        _derivative = ((_x0 select 1) - (_x1 select 1)) / _stride;
    };
    case (count _errorHistory >= 3): {
        private _xn0 = _errorHistory select -1;
        private _xn1 = _errorHistory select -2;
        private _xn2 = _errorHistory select -3;
        private _h = (_xn0 select 0) - (_xn1 select 0);
        if (_h == 0) then { break };

        private _sum = -3 * (_xn2 select 1) + 4 * (_xn1 select 1) - (_xn0 select 1);
        _derivative = _sum / (2 * _h);
    };
    default {};
};

private _sum = 0;
private _tn_prev = 0;
{
    if (_forEachIndex == 0) then { continue };
    _x params ["_tn", "_error"];
    private _stride = _tn - _tn_prev;
    if (_stride == 0) then { continue };
    _sum = _sum + (_error * _stride);
    _tn_prev = _tn;
} forEach _errorHistory;

private _deltaAltitude = (_error * _pGain + _sum * _iGain + _derivative * _dGain);

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

