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



[missionNamespace,"arsenalClosed", {
	if !([jen_player] call FUNC(hasJetpack)) exitwith {
	};
	jen_player setVariable [QGVAR(hasJetpack),true,true];
	private _pack = backpackContainer jen_player;
	private _packClass = typeOf _pack;
	private _coolCoef = [configFile >> "CfgVehicles" >> _packclass, QGVAR(coolCoef),1] call BIS_fnc_returnConfigEntry;
	[jen_player,_pack,_coolCoef] call FUNC(addCoolingHandle);
 }] call bis_fnc_addScriptedEventhandler;


//todo: convert from knd to jen
[QGVAR(particleEvent), {  
	if !(hasInterface) exitwith {};
	_this call FUNC(jetpackParticles);
}] call CBA_fnc_addEventHandler;  

[QGVAR(say3DGlobal), {
	params ["_object","_sound"];
	_object say3d _sound;
	}
] call CBA_fnc_addEventHandler;

[QGVAR(refuelItemBase), "CONTAINER", "Refuel Jetpack", nil, "\A3\ui_f\data\igui\cfg\simpleTasks\types\refuel_ca.paa", {[jen_player] call FUNC(hasJetpack)}, {
	params ["_unit", "_container", "_item", "_slot", "_params"];
	closeDialog 0;
	[_item] call FUNC(doRefuel);
	true
}, false, []] call CBA_fnc_addItemContextMenuOption;


["CAManBase", "GetOutMan", { 
 params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
 if !(jen_player == jen_player) exitwith {};
 if (vectorMagnitude (velocity _vehicle) < 3) exitWith {};
 
 if ([jen_player] call FUNC(hasJetpack)) then { 
  jen_player setUnitFreefallHeight (((_vehicle modelToWorld [0,0,0]) select 2)+ 200); 
  jen_player allowDamage false; 
  private _offset = random [-10,0,10]; 
  private _getOutPos = _vehicle modelToWorld [_offset,-30,0]; 
  jen_player setposASL (AGLToASL _getOutPos); 
  private _vehicleVel = velocity _vehicle; 
  jen_player setVelocity _vehicleVel; 
  jen_player setDir (getDir _vehicle);
  [{ 
  params ["_unit"]; 
  jen_player allowDamage true; 
  }, [jen_player], 1.5] call CBA_fnc_waitAndExecute; 
 }; 
 
}] call CBA_fnc_addClassEventHandler;

["CAManBase", "SlotItemChanged", {
	params ["_unit", "_name", "_slot", "_assigned"];
	if (_slot == 901) then {
		if ([jen_player] call FUNC(hasJetpack)) then {
			private _pack = backpackContainer jen_player;
			private _coolCoef = GET_NUMBER(configFile >> "CfgVehicles" >> typeOf _pack >> QGVAR(coolCoef),1);
			[jen_player,_pack,_coolCoef] call FUNC(addCoolingHandle);
		};
	};
}] call CBA_fnc_addClassEventHandler;


//todo: add isNil logic
bocr_main_varblacklist = bocr_main_varblacklist + [QGVAR(tankSize),QGVAR(coolDown),QGVAR(coolingHandle)];


[missionNamespace,"arsenalOpened", {	
	jen_player setvariable [QGVAR(controls_ascend),false]
 }] call bis_fnc_addScriptedEventhandler;

// Default max fuel, will only be used in weird situations (such as jetpack fuel being iterated before jetpack has been used)
GVAR(maxFuel) = 250;
GVAR(maxHeat) = 40;


// add EH to handle player changes 

["unit", {
    jen_player = (_this select 0);
}, true] call CBA_fnc_addPlayerEventHandler;

GVAR(timeSinceLastBeep) = 2;
call FUNC(initHUD);