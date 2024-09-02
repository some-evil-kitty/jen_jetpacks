// Written by Jenna
//
// Synchronizes jetpack variables across clients
//
// 

#include "script_component.hpp"

params ["_pack"];

private _heat = _pack getvariable [QGVAR(overheat),0];
private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
if (isNil {_maxFuel}) then {
	private _fuelCapacity = [configFile >> "CfgVehicles" >> typeOf _pack, QGVAR(fuelCapacity),GVAR(maxFuel)] call BIS_fnc_returnConfigEntry;
	_pack setVariable [QGVAR(tankSize),_fuelCapacity];
};
private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];
_pack setvariable [QGVAR(overheat), _heat, true];
_pack setvariable [QGVAR(fuelAmount), _fuel, true];
