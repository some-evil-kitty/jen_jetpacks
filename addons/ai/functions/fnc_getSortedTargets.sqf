#include "script_component.hpp"

params ["_unit"];

[array, parameters, algorithm, direction, filter] call BIS_fnc_sortBy

private _allTargets = _unit targets [true, CONTACT_MEDIUM_THRESHOLD];

if (_allTargets isEqualTo []) then {
    _allTargets = _unit targets [true, CONTACT_MAX_DISTANCE];
};

if (count _allTargets > CONTACT_MAX_TARGETS) then {
    _allTargets resize (CONTACT_MAX_TARGETS)
};

[_allTargets, [_unit], {_input0 distance2D _x}] call BIS_fnc_sortby;

_allTargets
