#include "script_component.hpp"

// Periodic cleanup of whatever we need to cleanup
GVAR(jetpackUnits) = GVAR(jetpackUnits) select {
    alive _x
};
private _seen = createHashmap;
GVAR(jetpackUnits) = GVAR(jetpackUnits) select {
    private _hash = hashValue _x;
    if (_hash in _seen) exitWith { false };
    _seen set [_hash, 0];
    true
};
GVAR(jetpackUnits) = GVAR(jetpackUnits) select {
    [_x] call EFUNC(core,hasJetpack)
};
