// Written by: Jenna
//
// adds cooling handle to a jetpack if it's not already there
//
//

#include "script_component.hpp"

params ["_unit","_pack","_coolCoef"];

if !(local _unit) exitWith {};

if (isNil {_pack getVariable [QGVAR(coolingHandle),nil]}) then {
	private _handle = [
	{
	if (isGamePaused) exitWith {};
	_this select 0 params ["_unit","_pack","_coolCoef"];
	if isNull _pack exitWith {
	[_this select 1] call CBA_fnc_removePerFrameHandler;
	_pack setVariable [QGVAR(coolingHandle),nil];
	};
	if (_unit getVariable [QGVAR(isJetpacking),false]) exitWith {};
	private _heat = _pack getVariable [QGVAR(overheat),0];
	if (_heat > 0) exitWith {_heat = _heat - (diag_deltaTime * _coolCoef);
	if (_heat < knd_jetpack_maxheat * 0.7) then { _pack setVariable [QGVAR(cooldown),false]};
	_pack setVariable [QGVAR(overheat),_heat];
	};
	if (_pack isNotEqualTo (backpackContainer _unit)) then {
		[_this select 1] call CBA_fnc_removePerFrameHandler;
		_pack setVariable [QGVAR(coolingHandle),nil];
		_pack setVariable [QGVAR(overheat),_heat,true];
	};
	
	}, 

	0, [_unit,_pack,_coolCoef]] call CBA_fnc_addPerFrameHandler;
	_pack setVariable [QGVAR(coolingHandle),_handle]
};
