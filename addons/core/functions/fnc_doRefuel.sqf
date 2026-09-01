// Written by: Jenna
//
// Refuels a worn jetpack and "eats" the provided item
//
// Example:
#include "script_component.hpp"


params ["_unit", "_item", "_jetpack", ["_fuelAmount", nil], ["_magazineData", [false,1]]];
_magazineData params ["_isMagazine", "_count"];

if (isNil {_fuelAmount}) then {
	private _config = configFile >> (["CfgWeapons", "CfgMagazines"] select _isMagazine) >> _item;
	_fuelAmount = GET_NUMBER(_config >> QGVAR(fuelCanAmount),200);
};

if !(isNil {ace_common}) then {
	[_unit, "Acts_carFixingWheel", 1] call ace_common_fnc_doAnimation;
	[ace_common_fnc_progressBar, 	[		
		5, 
		[_unit, _item, _jetpack, _fuelamount,_magazineData], 
		{
			_this select 0 params ["_unit", "_item", "_jetpack", "_fuelAmount", "_magazineData"];
			_magazineData params ["_isMagazine", "_count"];
			if (_isMagazine) then {
				[_unit, _item, _count] call FUNC(decrementMagazineAmmo);
			} else {
				_unit removeItem _item;
			};
			private _maxFuel = _jetpack getVariable [QGVAR(tankSize),nil];
			if (isNil {_maxFuel}) then {
			private _config = configOf _jetpack;
			private _fuelCapacity = GET_NUMBER(_config >> QGVAR(fuelCapacity),QGVAR(maxFuel));
			_jetpack setVariable [QGVAR(tankSize),_fuelCapacity];};
			private _fuel = _jetpack getVariable [QGVAR(fuelAmount),_maxFuel];
			[QGVAR(jetpackRefueled),[_jetpack,_fuel,_fuelAmount]] call CBA_fnc_localEvent;
			_fuel = (_fuel + _fuelAmount) min _maxFuel;
			_jetpack setVariable [QGVAR(fuelAmount),_fuel,true];
			[_unit, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation
		}, 
		{
			[_unit, "AmovPknlMstpSnonWnonDnon", 2] call ace_common_fnc_doAnimation;
			["Too far away to refuel.", true, 5, 2] call ace_common_fnc_displayText
		}
		, "Refueling Jetpack...",
		{
			_this select 0 params ["_unit", "_item", "_jetpack", "_fuelAmount", "_magazineData"];
			if (_unit != jen_player) then {
				(_unit distance jen_player) < 4 } 
			else {
			true
			}
		}
	] ] call CBA_fnc_execNextFrame;

} else {
	_unit switchMove "Acts_carFixingWheel";
	closeDialog 0;
	["Refueling Jetpack...", 5, {true}, {
		_this select 0 params ["_unit", "_item", "_jetpack", "_fuelAmount", "_magazineData"];
		_magazineData params ["_isMagazine", "_count"];
		if (_isMagazine) then {
			_unit removeMagazine _item;
		} else {
			_unit removeItem _item;
		};
		private _maxFuel = _jetpack getVariable [QGVAR(tankSize),nil];
		if (isNil {_maxFuel}) then {
		private _config = configOf _jetpack;
		private _fuelCapacity = GET_NUMBER(_config >> QGVAR(fuelCapacity),QGVAR(maxFuel));
		_jetpack setVariable [QGVAR(tankSize),_fuelCapacity];};
		private _fuel = _jetpack getVariable [QGVAR(fuelAmount),_maxFuel];
		[QGVAR(jetpackRefueled),[_jetpack,_fuel,_fuelAmount]] call CBA_fnc_localEvent;
		_fuel = (_fuel + _fuelAmount) min _maxFuel;
		_jetpack setVariable [QGVAR(fuelAmount),_fuel,true];
		_unit switchMove "AmovPknlMstpSnonWnonDnon";
	}, {_unit switchMove "AmovPknlMstpSnonWnonDnon";},[_unit, _item, _jetpack, _fuelamount, _magazineData]] call CBA_fnc_progressBar;
};
