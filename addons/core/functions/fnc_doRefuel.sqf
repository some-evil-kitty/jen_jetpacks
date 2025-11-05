// Written by: Jenna
//
// Refuels a worn jetpack and "eats" the provided item
//
// Example:
// ["knd_jetpackfuel", 200] call knd_fnc_jetpackRefuel
#include "script_component.hpp"


params ["_item",["_fuelAmount",nil],["_magazineData",[false,1]]];
_magazineData params ["_isMagazine","_count"];

if (isNil {_fuelAmount}) then {
	private _config = configFile >> (["CfgWeapons","CfgMagazines"] select _isMagazine) >> _item;
	_fuelAmount = GET_NUMBER(_config >> QGVAR(fuelCanAmount),200);
};

if !(isNil {ace_common}) then {
	[jen_player, "Acts_carFixingWheel", 2] call ace_common_fnc_doAnimation;
	[		
		5, 
		[_item, _fuelamount,_magazineData], 
		{
			_this select 0 params ["_item","_fuelAmount","_magazineData"];
			_magazineData params ["_isMagazine","_count"];
			private _pack = backpackContainer jen_player;
			if (_isMagazine) then {
				[jen_player, _item, -1] call ace_common_fnc_adjustMagazineAmmo;
			} else {
				jen_player removeItem _item;
			};
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
		_this select 0 params ["_item","_fuelAmount","_magazineData"];
		_magazineData params ["_isMagazine","_count"];
		private _pack = backpackContainer jen_player;
		if (_isMagazine) then {
			jen_player removeMagazine _item;
		} else {
			jen_player removeItem _item;
		};
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
	}, {jen_player switchMove "AmovPknlMstpSnonWnonDnon";},[_item, _fuelamount_magazineData]] call CBA_fnc_progressBar;
};
