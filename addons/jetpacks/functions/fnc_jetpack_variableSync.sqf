// Written by Jenna
//
// Synchronizes jetpack variables across clients
//
// 

#include "script_component.hpp"

params ["_pack"];

private _heat = _pack getvariable ["knd_jet_overheat",0];
private _maxFuel = _pack getVariable ["knd_jetpack_tankSize",nil];
if (isNil {_maxFuel}) then {
	private _fuelCapacity = [configFile >> "CfgVehicles" >> typeOf _pack, "knd_jetpack_fuelCapacity",knd_jetpack_maxfuel] call BIS_fnc_returnConfigEntry;
	_pack setVariable ["knd_jetpack_tankSize",_fuelCapacity];
};
private _fuel = _pack getVariable ["knd_jet_fuel",_maxFuel];
_pack setvariable ["knd_jet_overheat", _heat, true];
_pack setvariable ["knd_jet_fuel", _fuel, true];
