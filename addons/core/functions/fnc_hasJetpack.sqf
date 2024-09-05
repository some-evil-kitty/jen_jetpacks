// Written by: Jenna
//
// detects a worn jetpack
//
// after 2.18 this can be optimized with the [true] syntax (slotItemChanged is busted)

#include "script_component.hpp"

params [["_isPFH",false]];

if _isPFH exitwith {
private _isPack = jen_player getVariable [QGVAR(hasJetpack),false];
_isPack
};


private _pack = backpackContainer jen_player;
private _packclass = typeOf _pack;
private _isPack = GET_NUMBER(configFile >> "CfgVehicles" >> _packclass >> QGVAR(isJetpack),0) == 1;
jen_player setVariable [QGVAR(hasJetpack),_isPack,true];
_isPack
