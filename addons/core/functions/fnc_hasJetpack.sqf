// Written by: Jenna
//
// detects a worn jetpack
//


#include "script_component.hpp"

params [["_unit",jen_player]];

private _packClass = backpack _unit;

GVAR(hashCache) getOrDefault [_packClass,false,false]
