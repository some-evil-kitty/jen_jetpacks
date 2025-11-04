// Written by: Jenna
//
// Refuels a worn jetpack and "eats" the provided item
//
// Example:
// ["knd_jetpackfuel", 200] call knd_fnc_jetpackRefuel
#include "script_component.hpp"


params ["_item",["_fuelAmount",nil]];

if (isNil {_fuelAmount}) then {
private _config = configFile >> "CfgWeapons" >> _item;
_fuelAmount = GET_NUMBER(_config >> QGVAR(fuelCanAmount),200);
};

if !(isNil {ace_common}) then {
	[jen_player, "Acts_carFixingWheel", 2] call ace_common_fnc_doAnimation;
	[		
		5, 
		[_item, _fuelamount], 
		{
			_this select 0 params ["_item","_fuelAmount"];
			private _pack = backpackContainer jen_player;
			jen_player removeItem _item;
			private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
			if (isNil {_maxFuel}) then {
			private _config = configOf _pack;
			private _fuelCapacity = GET_NUMBER(_config >> QGVAR(fuelCapacity),QGVAR(maxFuel));
			_pack setVariable [QGVAR(tankSize),_fuelCapacity];};
			private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];
			[QGVAR(jetpackRefueled),[_pack,_fuel,_fuelAmount]] call CBA_fnc_localEvent;
			_fuel = (_fuel + _fuelAmount) min _maxFuel;
			_pack setVariable [QGVAR(fuelAmount),_fuel,true];
			[jen_player, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation
		}, 
		{
			[jen_player, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation
		}
		, "Refueling Jetpack..."
	] call ace_common_fnc_progressBar
} else {
	jen_player switchMove "Acts_carFixingWheel";
	closeDialog 0;

	["Refueling Jetpack...", 5, {true}, {
		_this select 0 params ["_item","_fuelAmount"];
		private _pack = backpackContainer jen_player;
		jen_player removeItem _item;
		private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
		if (isNil {_maxFuel}) then {
		private _config = configOf _pack;
		private _fuelCapacity = GET_NUMBER(_config >> QGVAR(fuelCapacity),QGVAR(maxFuel));
		_pack setVariable [QGVAR(tankSize),_fuelCapacity];};
		private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];
		[QGVAR(jetpackRefueled),[_pack,_fuel,_fuelAmount]] call CBA_fnc_localEvent;
		_fuel = (_fuel + _fuelAmount) min _maxFuel;
		_pack setVariable [QGVAR(fuelAmount),_fuel,true];
		jen_player switchMove "AmovPknlMstpSnonWnonDnon";
	}, {jen_player switchMove "AmovPknlMstpSnonWnonDnon";},[_item, _fuelamount]] call CBA_fnc_progressBar;
};
