#include "script_component.hpp"

// only executed on client



["ace_arsenal_displayclosed", {
	if !([jen_player] call FUNC(hasJetpack)) exitWith {
	jen_player setVariable [QGVAR(hasJetpack),false,true];
	};
	jen_player setVariable [QGVAR(hasJetpack),([jen_player] call FUNC(hasJetpack)),true];
	private _pack = backpackContainer jen_player;
	private _packClass = typeOf _pack;
	private _coolCoef = [configFile >> "CfgVehicles" >> _packclass, QGVAR(coolCoef),1] call BIS_fnc_returnConfigEntry;
	[jen_player,_pack,_coolCoef] call FUNC(addCoolingHandle);
	}] call CBA_fnc_addEventHandler;


private _action = 
[
	QGVAR(refuelAction), //Action name
	"Refuel Jetpack", //Display name
	"\z\ace\addons\refuel\ui\icon_refuel_interact.paa", 
	{["", 100] call FUNC(doRefuel)}, //Code
	{
		_pack = backpackContainer jen_player;
		_packclass = typeOf _pack;
		_isPack = [configFile >> "CfgVehicles" >> _packclass, QGVAR(isJetpack),0] call BIS_fnc_returnConfigEntry;
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
	QGVAR(refuelAction), //Action name
	"Refuel Jetpack", //Display name
	"\z\ace\addons\refuel\ui\icon_refuel_interact.paa", //Icon path
	{["", 100] call FUNC(doRefuel)}, //Code
	{
		_pack = backpackContainer jen_player;
		_packclass = typeOf _pack;
		_isPack = [configFile >> "CfgVehicles" >> _packclass, QGVAR(isJetpack),0] call BIS_fnc_returnConfigEntry;
		([_this select 0] call ace_refuel_fnc_getFuel > 10) AND (_isPack == 1)
		
	}, // Condition
	{}, //Children code
	[], // Params
	[0,0,0], // Position
	10 // Distance
] call ace_interact_menu_fnc_createAction;

[_source, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;

}] call CBA_fnc_addEventHandler;  
