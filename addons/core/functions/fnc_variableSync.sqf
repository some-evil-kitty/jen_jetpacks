// Written by Jenna
//
// Synchronizes jetpack variables across clients
//
// 

#include "script_component.hpp"

params ["_pack"];

private _heat = _pack getVariable [QGVAR(overheat),0];
private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
if (isNil {_maxFuel}) then {
	private _fuelCapacity = GET_NUMBER(configFile >> "CfgVehicles" >> typeOf _pack >> QGVAR(fuelCapacity),GVAR(maxFuel));
	_pack setVariable [QGVAR(tankSize),_fuelCapacity];
};
private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];
_pack setVariable [QGVAR(overheat), _heat, true];
_pack setVariable [QGVAR(fuelAmount), _fuel, true];
