// Written by: Jenna
//
// Refuels a worn jetpack and "eats" the provided item
//
// Example:
// ["knd_jetpackfuel", 200] call knd_fnc_jetpackRefuel
#include "script_component.hpp"


params ["_item","_fuelamount"];


[ace_player, "Acts_carFixingWheel", 1] call ace_common_fnc_doAnimation;
[		
	5, 
	[_item, _fuelamount], 
	{
		_this select 0 params ["_item","_fuelamount"];
		private _pack = backpackContainer ace_player;
		ace_player removeitem _item;
		private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
		if (isNil {_maxFuel}) then {
		private _fuelCapacity = [configFile >> "CfgVehicles" >> typeOf _pack, QGVAR(fuelCapacity),GVAR(maxFuel)] call BIS_fnc_returnConfigEntry;
		_pack setVariable [QGVAR(tankSize),_fuelCapacity];};
		private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];
		_fuel = (_fuel + _fuelamount) min _maxFuel;
		//systemchat str _fuel;
		_pack setvariable [QGVAR(fuelAmount),_fuel,true];
		[ace_player, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation
		
		
	}, 
	{
		[ace_player, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation
	}
	, "Refueling Jetpack..."
] call ace_common_fnc_progressBar