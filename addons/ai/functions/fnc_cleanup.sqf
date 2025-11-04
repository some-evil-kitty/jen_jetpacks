#include "script_component.hpp"

// Periodic cleanup of whatever we need to cleanup
private _seen = createHashMap;
GVAR(jetpackUnits) = GVAR(jetpackUnits) select {
    alive _x
} select {
    private _hash = hashValue _x;
    if (_hash in _seen) then {
        false
    } else {
        _seen set [_hash, 0];
        true
    }
} select {
    [_x] call EFUNC(core,hasJetpack)
};
