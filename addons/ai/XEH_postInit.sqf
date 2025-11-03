#include "script_component.hpp"

// Units that are wearing the jetpack
GVAR(debug) = false;
#ifdef DEBUG_MODE_FULL
GVAR(debug) = true;
#endif

GVAR(jetpackUnits) = [];

GVAR(defaultFlightTolerance) = 0.15; // percent
GVAR(defaultHoverTolerance) = 0.05; // percent
GVAR(defaultHoverHeight) = 10;  // meters
GVAR(defaultRotateSpeed) = 30;     // degrees/second

GVAR(fsm_flightManager) = [configFile >> QGVAR(fsm_flightManager)] call CBA_statemachine_fnc_createFromConfig;
[{
    if !(GVAR(debug)) exitWith {};
    params ["_args"];
    _args params ["_fsm"];

    private _list = _fsm getVariable "cba_statemachine_list";
    {
        private _state = [_x, _fsm] call CBA_statemachine_fnc_getCurrentState;
        drawIcon3D [
            "",
            [0, 0, 1, 1],
            getPos _x,
            1,
            1,
            0,
            format ["State: %1", _state],
            0,
            0.05,
            "PuristaMedium",
            "center",
            false
        ];
    } forEach _list;
}, 0, [GVAR(fsm_flightManager)]] call CBA_fnc_addPerFrameHandler;
