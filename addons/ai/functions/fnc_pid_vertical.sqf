#include "script_component.hpp"

params ["_unit"];

private _verticalAltitudePid = _unit getVariable QGVAR(pid_verticalAltitude);
_verticalAltitudePid params ["_pGain", "_iGain", "_dGain", "_errorHistory", "_setpoint"];

private _error = _setpoint - ((getPosATLVisual _unit) select 2);
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
    _x params ["_tn", "_error"];
    private _stride = _tn - _tn_prev;
    if (_stride == 0) then { continue };
    _sum = _sum + (_error / _stride);
    _tn_prev = _tn;
} forEach _errorHistory;

private _deltaAltitude = _error * _pGain + _sum * _iGain + _derivative * _dGain;
private _fuzz = _unit getVariable QGVAR(hover_allowableError);

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

private _commandedAcceleration = _deltaAltitude / (_timeToGo ^ 2);
private _ratio = _commandedAcceleration / _a;

private _command = false;
if (_a > 0) then {
    _command = _ratio > (1 - GVAR(defaultHoverTolerance));
} else {
    _command = _ratio < (1 + GVAR(defaultHoverTolerance));
};

_unit setVariable [QEGVAR(core,controlUp), _command];
