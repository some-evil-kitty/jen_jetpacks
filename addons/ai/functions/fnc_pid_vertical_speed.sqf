#include "script_component.hpp"

params ["_unit"];

private _verticalAltitudePid = _unit getVariable QGVAR(pid_verticalSpeed);
_verticalAltitudePid params ["_pGain", "_iGain", "_dGain", "_errorHistory", "_setpoint"];

private _error = _setpoint - ((velocity _unit) select 2);
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

private _deltaVelocity = _error * _pGain + _sum * _iGain + _derivative * _dGain;
_deltaVelocity
