#include "script_component.hpp"
ADDON = false;


#include "XEH_PREP.hpp"


ADDON = true;

// ace fuel attempts

["ace_refuel_sourceInitialized", {
params ["_source"];  
private _action = 
[
	QGVAR(refuelAction), //Action name
	"Refuel Jetpack", //Display name
	"\z\ace\addons\refuel\ui\icon_refuel_interact.paa", //Icon path
	{[jen_player, "", backpackContainer jen_player, 100] call EFUNC(core,doRefuel)}, //Code
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
