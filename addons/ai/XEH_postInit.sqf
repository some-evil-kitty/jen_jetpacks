#include "script_component.hpp"

// Units that are wearing the jetpack
GVAR(debug) = false;
#ifdef DEBUG_MODE_FULL
GVAR(debug) = true;
#endif

GVAR(jetpackUnits) = [];

GVAR(defaultFlightTolerance) = 0.15; // percent
GVAR(defaultHoverTolerance) = 0.05; // percent
GVAR(defaultHoverHeight) = 7;  // meters
GVAR(defaultRotateSpeed) = 60;     // degrees/second

GVAR(fsm_flightManager) = [configFile >> QGVAR(fsm_flightManager)] call CBA_statemachine_fnc_createFromConfig;
GVAR(fsm_combatManager) = [configFile >> QGVAR(fsm_combatManager)] call CBA_statemachine_fnc_createFromConfig;
[QFUNC(cleanup), 10] call CBA_fnc_addPerFrameHandler;

[{
    if !(GVAR(debug)) exitWith {};
    {
        private _flightState = [_x, GVAR(fsm_flightManager)] call CBA_statemachine_fnc_getCurrentState;
        private _combatState = [_x, GVAR(fsm_combatManager)] call CBA_statemachine_fnc_getCurrentState;
        private _basePos = getPosATLVisual _x;

        drawIcon3D [
            "",
            [0, 0, 1, 1],
            _basePos vectorAdd [0, 0, 0.5],
            1,
            1,
            0,
            format ["Flight State: %1", _flightState],
            0,
            0.05,
            "PuristaMedium",
            "center",
            false
        ];

        drawIcon3D [
            "",
            [1, 0, 0, 1],
            _basePos vectorAdd [0, 0, -0.5],
            1,
            1,
            0,
            format ["Combat State: %1", _combatState],
            0,
            0.05,
            "PuristaMedium",
            "center",
            false
        ];
    } forEach GVAR(jetpackUnits);
}] call CBA_fnc_addPerFrameHandler;
