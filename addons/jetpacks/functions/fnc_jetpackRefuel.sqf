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
		private _maxFuel = _pack getVariable ["knd_jetpack_tankSize",nil];
		if (isNil {_maxFuel}) then {
		private _fuelCapacity = [configFile >> "CfgVehicles" >> typeOf _pack, "knd_jetpack_fuelCapacity",knd_jetpack_maxfuel] call BIS_fnc_returnConfigEntry;
		_pack setVariable ["knd_jetpack_tankSize",_fuelCapacity];};
		private _fuel = _pack getVariable ["knd_jet_fuel",_maxFuel];
		_fuel = (_fuel + _fuelamount) min _maxFuel;
		//systemchat str _fuel;
		_pack setvariable ["knd_jet_fuel",_fuel,true];
		[ace_player, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation
		
		
	}, 
	{
		[ace_player, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation
	}
	, "Refueling Jetpack..."
] call ace_common_fnc_progressBar