// Written by: Jenna
//
//
// caches all jetpacks on postinit so HUD saves performance
//
//

#include "script_component.hpp"

private _vehicles = [configFile >> "CfgVehicles"] call BIS_fnc_getCfgSubClasses; 
private _backpacks = _vehicles select {
	private _config = configFile >> "CfgVehicles" >> _x;
	GET_NUMBER(_config >> "isbackpack",0) == 1
};

private _jetpacks = _backpacks select {
	private _config = configFile >> "CfgVehicles" >> _x;
	GET_NUMBER(_config >> QGVAR(isJetpack),0) == 1
};

GVAR(hashCache) = createHashMap;

{
	GVAR(hashCache) set [_x,true]
} forEach _jetpacks;
