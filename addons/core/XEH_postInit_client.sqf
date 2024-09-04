#include "script_component.hpp"
#include "\a3\ui_f\hpp\definedikcodes.inc"
// only executed on client

[
	"KJW's Jetpacks",
	QGVAR(controls_activate),
	"Jetpack - Toggle On/Off",
	{
		[jen_player] call FUNC(doJetpack);
		if (GVAR(alternateControls)) then {jen_player setvariable [QGVAR(controlUp),true]};
		
	},
	{
		if (GVAR(alternateControls)) then {jen_player setvariable [QGVAR(controlUp),false]};
	},
	[DIK_SPACE,[false,true,false]]
] call CBA_fnc_addKeybind;

[
	"KJW's Jetpacks",
	QGVAR(controls_ascend),
	"Jetpack - Up",
	{
		jen_player setvariable [QGVAR(controlUp),true]
	},
	{
		jen_player setvariable [QGVAR(controlUp),false]
	},
	[DIK_SPACE,[false,false,false]]
] call CBA_fnc_addKeybind;

["ace_arsenal_displayclosed", {
	if !([false] call knd_fnc_hasjetpack) exitwith {
	_unit setVariable ["knd_jenpacks_hasJetpack",false,true];
	};
	ACE_PLAYER setVariable ["knd_jenpacks_hasJetpack",([false] call knd_fnc_hasjetpack),true];
	private _pack = backpackContainer ace_player;
	private _packClass = typeOf _pack;
	private _coolCoef = [configFile >> "CfgVehicles" >> _packclass, "knd_jetpack_coolCoef",1] call BIS_fnc_returnConfigEntry;
	if (isNil {_pack getVariable ["knd_jetpacks_coolingHandle",nil]}) then {
		private _handle = [
		{
		if (isGamePaused) exitWith {};
		_this select 0 params ["_pack","_coolCoef"];
				if isNull _pack exitwith {
				[_this select 1] call CBA_fnc_removePerFrameHandler;
			};
		if (ace_player getVariable ["knd_isJetpacking",false]) exitwith {};
		private _heat = _pack getvariable ["knd_jet_overheat",0];
		private _fuel = _pack getVariable ["knd_jet_fuel",knd_jetpack_maxfuel];
		if (_heat > 0) exitwith {_heat = _heat - (diag_deltaTime * _coolCoef);
		if (_heat < knd_jetpack_maxheat * 0.7) then { _pack setVariable ["knd_jet_cooldown",false]};
		_pack setVariable ["knd_jet_overheat",_heat];
		};
		if !(_pack isEqualTo (backpackContainer ace_player)) then {
			[_this select 1] call CBA_fnc_removePerFrameHandler;
			_pack setVariable ["knd_jetpacks_coolingHandle",nil];
			_pack setVariable ["knd_jet_overheat",_heat,true];
		};
		
		}, 
	
		0, [_pack,_coolCoef]] call CBA_fnc_addPerFrameHandler;
		_pack setVariable ["knd_jetpacks_coolingHandle",_handle]
	};
	}] call CBA_fnc_addEventHandler;


//todo: convert to cooling handle fnc
[missionNamespace,"arsenalClosed", {
	if !([false] call knd_fnc_hasjetpack) exitwith {
	};
	ACE_PLAYER setVariable ["knd_jenpacks_hasJetpack",true,true];
	private _pack = backpackContainer ace_player;
	private _packClass = typeOf _pack;
	private _coolCoef = [configFile >> "CfgVehicles" >> _packclass, "knd_jetpack_coolCoef",1] call BIS_fnc_returnConfigEntry;
	if (isNil {_pack getVariable ["knd_jetpacks_coolingHandle",nil]}) then {
		private _handle = [
		{
		if (isGamePaused) exitWith {};
		_this select 0 params ["_pack","_coolCoef"];
			if isNull _pack exitwith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;
	};
		if (ace_player getVariable ["knd_isJetpacking",false]) exitwith {};
		private _heat = _pack getvariable ["knd_jet_overheat",0];
		private _fuel = _pack getVariable ["knd_jet_fuel",knd_jetpack_maxfuel];
		if (_heat > 0) exitwith {_heat = _heat - (diag_deltaTime * _coolCoef);
		if (_heat < knd_jetpack_maxheat * 0.7) then { _pack setVariable ["knd_jet_cooldown",false]};
		_pack setVariable ["knd_jet_overheat",_heat];
		};
		if !(_pack isEqualTo (backpackContainer ace_player)) then {
			[_this select 1] call CBA_fnc_removePerFrameHandler;
			_pack setVariable ["knd_jetpacks_coolingHandle",nil];
			_pack setVariable ["knd_jet_overheat",_heat,true];
		};
		
		}, 
	
		0, [_pack,_coolCoef]] call CBA_fnc_addPerFrameHandler;
		_pack setVariable ["knd_jetpacks_coolingHandle",_handle]
	};
 }] call bis_fnc_addScriptedEventhandler;


//todo: convert from knd to jen
["knd_jetpackParticleEvent", {  
	if !(hasInterface) exitwith {};
	_this call KND_fnc_jetpackParticles;
}] call CBA_fnc_addEventHandler;  


["knd_jetpackfuel", "CONTAINER", "Refuel Jetpack", nil, "\A3\ui_f\data\igui\cfg\simpleTasks\types\refuel_ca.paa", {[ace_player] call knd_fnc_hasJetpack}, {
	params ["_unit", "_container", "_item", "_slot", "_params"];
	[_item,200] call knd_fnc_jetpackrefuel
}, false, []] call CBA_fnc_addItemContextMenuOption;

["CAManBase", "GetOutMan", { 
 params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
 if !(_unit == ace_player) exitwith {};
 if (vectorMagnitude (velocity _vehicle) < 3) exitWith {};
 
 if ([false] call knd_fnc_hasjetpack) then { 
  _unit setUnitFreefallHeight (((_vehicle modelToWorld [0,0,0]) select 2)+ 200); 
  _unit allowDamage false; 
  private _offset = random [-10,0,10]; 
  private _getOutPos = _vehicle modelToWorld [_offset,-30,0]; 
  _unit setposASL (AGLToASL _getOutPos); 
  private _vehicleVel = velocity _vehicle; 
  _unit setVelocity _vehicleVel; 
  _unit setDir (getDir _vehicle);
  [{ 
  params ["_unit"]; 
  _unit allowDamage true; 
  }, [_unit], 1.5] call CBA_fnc_waitAndExecute; 
 }; 
 
}] call CBA_fnc_addClassEventHandler;

["CAManBase", "SlotItemChanged", {
	params ["_unit", "_name", "_slot", "_assigned"];
	if (_slot == 901) then {
		if ([false] call knd_fnc_hasjetpack) then {
			private _pack = backpackContainer _unit;
			private _packClass = typeOf _pack;
			private _coolCoef = [configFile >> "CfgVehicles" >> _packclass, "knd_jetpack_coolCoef",1] call BIS_fnc_returnConfigEntry;
			if (isNil {_pack getVariable ["knd_jetpacks_coolingHandle",nil]}) then {
				private _handle = [
				{
				if (isGamePaused) exitWith {};
				_this select 0 params ["_pack","_coolCoef"];
				if isNull _pack exitwith {
					[_this select 1] call CBA_fnc_removePerFrameHandler;
				};
				if (ace_player getVariable ["knd_isJetpacking",false]) exitwith {};
				private _heat = _pack getvariable ["knd_jet_overheat",0];
				private _fuel = _pack getVariable ["knd_jet_fuel",knd_jetpack_maxfuel];
				if (_heat > 0) exitwith {_heat = _heat - (diag_deltaTime * _coolCoef);
				if (_heat < knd_jetpack_maxheat * 0.7) then { _pack setVariable ["knd_jet_cooldown",false]};
				_pack setVariable ["knd_jet_overheat",_heat];
				};
				if !(_pack isEqualTo (backpackContainer ace_player)) then {
					[_this select 1] call CBA_fnc_removePerFrameHandler;
					_pack setVariable ["knd_jetpacks_coolingHandle",nil];
					_pack setVariable ["knd_jet_overheat",_heat,true];
				};
				
				}, 
			
				0, [_pack,_coolCoef]] call CBA_fnc_addPerFrameHandler;
				_pack setVariable ["knd_jetpacks_coolingHandle",_handle]
			};
		};
	};
}] call CBA_fnc_addClassEventHandler;


//todo: add isNil logic
bocr_main_varblacklist = bocr_main_varblacklist + ["knd_jetpack_tanksize","knd_jet_cooldown","knd_jetpacks_coolinghandle"];

//todo: conversion

private _action = 
[
	"knd_refuel_action", //Action name
	"Refuel Jetpack", //Display name
	"\z\ace\addons\refuel\ui\icon_refuel_interact.paa", //Icon path
	{["", 100] call knd_fnc_jetpackRefuel}, //Code
	{
		_pack = backpackContainer ace_player;
		_packclass = typeOf _pack;
		_isPack = [configFile >> "CfgVehicles" >> _packclass, "knd_isJetpack",0] call BIS_fnc_returnConfigEntry;
		([_this select 0] call ace_refuel_fnc_getFuel > 10) AND (_isPack == 1)
		
	}, // Condition
	{}, //Children code
	[], // Params
	[0,0,0], // Position
	10 // Distance
] call ace_interact_menu_fnc_createAction;
[
	"AllVehicles", // Class name
	 0, // Type of action (1 for self, 0 for main)
	 ["ACE_MainActions"], //Parent path 
	 _action,
	 true
] call ace_interact_menu_fnc_addActionToClass;
 
[
	"ReammoBox_F", // Class name
	 0, // Type of action (1 for self, 0 for main)
	 ["ACE_MainActions"], //Parent path 
	 _action,
	 true
] call ace_interact_menu_fnc_addActionToClass;


["ace_refuel_sourceInitialized", {
params ["_source"];  
private _action = 
[
	"knd_refuel_action", //Action name
	"Refuel Jetpack", //Display name
	"\z\ace\addons\refuel\ui\icon_refuel_interact.paa", //Icon path
	{["", 100] call knd_fnc_jetpackRefuel}, //Code
	{
		_pack = backpackContainer ace_player;
		_packclass = typeOf _pack;
		_isPack = [configFile >> "CfgVehicles" >> _packclass, "knd_isJetpack",0] call BIS_fnc_returnConfigEntry;
		([_this select 0] call ace_refuel_fnc_getFuel > 10) AND (_isPack == 1)
		
	}, // Condition
	{}, //Children code
	[], // Params
	[0,0,0], // Position
	10 // Distance
] call ace_interact_menu_fnc_createAction;

[_source, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

}] call CBA_fnc_addEventHandler;  




[missionNamespace,"arsenalOpened", {	
	ace_player setvariable ["knd_jet_Hover",false]
 }] call bis_fnc_addScriptedEventhandler;

// Default max fuel, will only be used in weird situations (such as jetpack fuel being iterated before jetpack has been used)
knd_jetpack_maxfuel = 250;


// add EH to handle player changes 

["unit", {
    jen_player = (_this select 0);
}, true] call CBA_fnc_addPlayerEventHandler;
