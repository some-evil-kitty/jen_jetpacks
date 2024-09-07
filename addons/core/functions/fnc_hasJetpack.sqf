// Written by: Jenna
//
// detects a worn jetpack
//
// after 2.18 this can be optimized with the [true] syntax (slotItemChanged is busted)

#include "script_component.hpp"

params [["_unit",jen_player]];

private _pack = backpackContainer _unit;
private _packClass = typeOf _pack;

GVAR(hashCache) getOrDefault [_packClass,false,false]