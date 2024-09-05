// Written by: Jenna
//
// Refuels a worn jetpack and "eats" the provided item
//
// Example:
// ["knd_jetpackfuel", 200] call knd_fnc_jetpackRefuel
#include "script_component.hpp"


params ["_item",["_fuelAmount",nil]];

if (isNil _fuelAmount) then {
private _config = configFile >> "CfgWeapons" >> _item;
_fuelAmount = GET_NUMBER(_config >> QGVAR(fuelCanAmount),200);
};

//animation is ultimately inconsequential, can deal with the strangeness of switchMove
jen_player switchMove "Acts_carFixingWheel";
["Refueling Jetpack...", 5, {true}, {
	_this select 0 params ["_item","_fuelAmount"];
	private _pack = backpackContainer jen_player;
	jen_player removeitem _item;
	private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
	if (isNil {_maxFuel}) then {
	private _fuelCapacity = GET_NUMBER(configFile >> "CfgVehicles" >> typeOf _pack, QGVAR(fuelCapacity),QGVAR(maxFuel));
	_pack setVariable [QGVAR(tankSize),_fuelCapacity];};
	private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];
	[QGVAR(jetpackRefueled),[_pack,_fuel,_fuelAmount]] call CBA_fnc_localEvent;
	_fuel = (_fuel + _fuelAmount) min _maxFuel;
	_pack setvariable [QGVAR(fuelAmount),_fuel,true];
	jen_player switchMove "AmovPknlMstpSnonWnonDnon";
}, {jen_player switchMove "AmovPknlMstpSnonWnonDnon";},[_item, _fuelamount]] call CBA_fnc_progressBar;
