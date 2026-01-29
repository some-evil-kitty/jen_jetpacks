#include "script_component.hpp"

params ["_unit"];

private _assigned = assignedTarget _unit;
if !(isNull _assigned) exitWith {
    _assigned
};

private _firing = getAttackTarget _unit;
if !(isNull _firing) exitWith {
    _firing
};

private _allTargets = [_unit, FUNC(getSortedTargets), _unit, QGVAR(sortedTargets), 2] call EFUNC(core,cachedCall);

_allTargets = _allTargets select {alive _x};

if (_allTargets isEqualTo []) then {
    [_unit, GVAR(fsm_combatManager), ([_unit, GVAR(fsm_combatManager)] call CBA_statemachine_fnc_getCurrentState), "Idle"] call CBA_statemachine_fnc_manualTransition;
    objNull
};

private _bestTarget = _allTargets#0;

_bestTarget
