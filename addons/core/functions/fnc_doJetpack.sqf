// Written by: Jenna
//
//
//
// Performs all checks for jetpack and turns it on/off as needed. Backpack must contain knd_isjetpack = 1 in order to be considered a jetpack.
//
//
//
//
#include "script_component.hpp"

params ["_unit"];

if (vehicle _unit != _unit OR (lifeState _unit == "INCAPACITATED") OR (_unit getVariable ["ace_dragging_isDragging",false]) OR (_unit getVariable ["ace_captives_isHandcuffed",false])) exitwith {}; 


if (_unit getVariable [QGVAR(jetpackDisabled),false]) exitwith {};


private _pack = backpackContainer _unit;
private _packclass = typeOf _pack;
private _config = configFile >> "CfgVehicles" >> _packclass;
private _isPack = (GET_NUMBER(_config >> QGVAR(isJetpack),0) == 1);


if !_isPack exitwith {}; //Not wearing a jetpack!

if (GVAR(debounce)) exitwith {};

GVAR(debounce) = true;

[{
GVAR(debounce) = false;			
}, [], 0.1] call CBA_fnc_waitAndExecute;

private _acceleration = GET_NUMBER(_config >> QGVAR(acceleration),4);
private _resistance = GET_NUMBER(_config >> QGVAR(drag),6);
private _fuelCoef = GET_NUMBER(_config >> QGVAR(fuelCoef),1);
private _heatCoef = GET_NUMBER(_config >> QGVAR(heatCoef),1);
private _coolCoef = GET_NUMBER(_config >> QGVAR(coolCoef),1);
private _strafeCoef = GET_NUMBER(_config >> QGVAR(strafeCoef),1);
private _ascensionCoef = GET_NUMBER(_config >> QGVAR(ascensionCoef),1);
private _jumpCoef = GET_NUMBER(_config >> QGVAR(jumpCoef),1);
private _fuelCapacity = GET_NUMBER(_config >> QGVAR(fuelCapacity),GVAR(maxFuel));

//allow external disablement of jetpacks and modification fom custom conditions
[QGVAR(jetpackEvent), [_unit,_isPack,_acceleration,_resistance,_fuelCoef,_heatCoef,_coolCoef,_strafeCoef,_ascensionCoef,_jumpCoef,_fuelCapacity]] call CBA_fnc_localEvent;

// check again; event may have changed this
if !_isPack exitwith {}; //Not wearing a jetpack!

if ((secondaryWeapon _unit) isNotEqualTo "") then {
	_acceleration = _acceleration min 2.5;
	_resistance = _resistance * 1.2;
	_ascensionCoef = _ascensionCoef  * 0.8;
};

if (((secondaryWeapon _unit) isNotEqualTo "") AND (_isRocketPack)) exitwith {
};


_pack setVariable [QGVAR(tankSize),_fuelCapacity];

[_unit,_pack,_coolCoef] call FUNC(addCoolingHandle);

if !([GVAR(mainHandle)] call CBA_fnc_removePerFrameHandler) then {


//Reset or set the idle timer 
_unit setvariable [QGVAR(idleTimer),0.2];  


private _oldfreefall = (getUnitFreefallInfo _unit) select 2;

// No freefall!
_unit setunitFreefallHeight 10000;


// "Jump" when starting out
private _pack = backpackContainer _unit;
private _fuel = _pack getVariable [QGVAR(fuelAmount),_fuelCapacity];


if (isTouchingGround _unit AND _fuel > 0.1 AND !(_pack getVariable [QGVAR(cooldown),false])) then
{
	_pos = getposASL _unit;
	_pos set [2, (_pos select 2) + 0.05];
	_vel = velocity _unit;
	_vel set [2, (_vel select 2) + 7 * _jumpCoef];
	_unit setposASL _pos;
	_unit setvelocity _vel;
	playsound3d [QPATHTOF(snd\jetpack_ignition.wss), _unit, false, getposASL _unit,5,1,30];
};

[QGVAR(say3dGlobal), [_source,QGVAR(soundLoop)]] call CBA_fnc_globalEvent;
[QGVAR(particleEvent), [_unit,true]] call CBA_fnc_globalEvent;

//Tag player as jetpacking

_unit setVariable [QGVAR(isJetpacking),true];

//Add the PFH
GVAR(mainHandle) = [{

// Prevent backlog when paused or alt-tabbed
if (isGamePaused) exitWith {};


_this select 0 params ["_unit","_acceleration","_resistance","_fuelCoef","_heatCoef","_ascensionCoef","_strafeCoef","_oldfreefall"];
// Make sure damage is allowed
//_unit allowdamage true; 



// Get our variables
private _pack = backpackContainer _unit;
private _heat = _pack getvariable [QGVAR(overheat),0];
private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
if (isNil {_maxFuel}) then {
	private _fuelCapacity = GET_NUMBER(configFile >> "CfgVehicles" >> typeOf _pack, QGVAR(fuelCapacity),GVAR(maxFuel));
	_pack setVariable [QGVAR(tankSize),_fuelCapacity];
};
private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];



// Keep uncon people from continuing to fly
if (isNull _pack OR !alive _unit OR !([_unit] call ace_common_fnc_isAwake) or _unit getVariable [QGVAR(jetpackDisabled),false]) exitwith 
{
	[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(isJetpacking),false];
	[_this select 1] call CBA_fnc_removePerFrameHandler;
	[GVAR(soundHandle)] call CBA_fnc_removePerFrameHandler;
	[_pack] call FUNC(variableSync);

};






// Make sure you can take damage while on the ground, reset freefall height. It's more performant to do this each frame of the handler than to check. Also, increment the idle timer.
if (isTouchingGround _unit or [_unit] call FUNC(isSwimming) or (vehicle _unit != _unit) OR (lifeState _unit == "INCAPACITATED") OR ((getPosVisual _unit) select 2 < 0.05)) exitwith 
{
	//_unit allowdamage true; 
	_unit setunitFreefallHeight _oldfreefall;
	if (_heat > 0) then {_heat = _heat - diag_deltaTime};
	if (_heat < GVAR(maxHeat) * 0.7) then { _pack setVariable [QGVAR(cooldown),false]};
	_pack setVariable [QGVAR(overheat),_heat];
	private _idletimer = _unit getvariable [QGVAR(idleTimer),2];
	_idletimer = _idletimer - diag_deltaTime;
	_unit setvariable [QGVAR(idleTimer),_idletimer];
	if (_idletimer < 0) exitwith 
	{
		[_this select 1] call CBA_fnc_removePerFrameHandler;
		[GVAR(soundHandle)] call CBA_fnc_removePerFrameHandler;
		[_pack] call FUNC(variableSync);
		[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
		_unit setVariable [QGVAR(isJetpacking),false];
		playsound3d [QPATHTOF(snd\jetpack_off.wss), _unit, false, getposASL _unit, 5,1,20];
		private _source = _unit getVariable [QGVAR(soundSource),objNull];
		deleteVehicle _source;
	};
};

//Reset the idle timer if you're not on the ground

_unit setvariable [QGVAR(idleTimer),0.2];  


//If player is on cooldown (due to overheating), only do the heat reduction and the fall damage un-fuckery
if (_pack getVariable [QGVAR(cooldown),false] OR _fuel < 0.01) exitwith 
{
	if (_heat > 0) then {_heat = _heat - 2 *diag_deltaTime};
	_pack setVariable [QGVAR(overheat),_heat];
};


// Handle overheating
if (_heat > GVAR(maxHeat)) exitwith {
	_heat = _heat + 5;
	_pack setVariable [QGVAR(cooldown),true];
	[_this select 1] call CBA_fnc_removePerFrameHandler;
	[GVAR(soundHandle)] call CBA_fnc_removePerFrameHandler;
	[_pack] call FUNC(variableSync);
	[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(isJetpacking),false];
	private _source = _unit getVariable [QGVAR(soundSource),objNull];
	deleteVehicle _source;
	playsound3d [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getposASL _unit, 5,1,10];
};

// Reset overheating if needed (will only be needed in select situations, likely almost never)
 _pack setVariable [QGVAR(cooldown),false];



// Define our direction and velocity variables
private _dir = direction _unit;
private _vel = velocity _unit;



// Check for controls, change velocity variable accordingly. Multiply by previous frametime to normalize for different performance situations.
if (inputAction "MoveForward" == 1) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - (_fuelCoef * diag_deltaTime);
_speed = diag_deltaTime * 5 * _acceleration;
_vel = [
	(_vel select 0) + (sin _dir * _speed),
	(_vel select 1) + (cos _dir * _speed),
	(_vel select 2) + (5 * diag_deltaTime)
];};

if (inputAction "TurnRight" == 1) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - diag_deltaTime;
_speed = diag_deltaTime * 5 * _acceleration * _strafeCoef;
_vel =  [
	(_vel select 0) + (sin (_dir + 90) * _speed),
	(_vel select 1) + (cos (_dir + 90) * _speed),
	(_vel select 2) + (4.9 * diag_deltaTime)
];};

if (inputAction "TurnLeft" == 1) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - diag_deltaTime;
_speed = diag_deltaTime * 5 * _acceleration * _strafeCoef;
_vel =  [
	(_vel select 0) + (sin (_dir - 90) * _speed),
	(_vel select 1) + (cos (_dir - 90) * _speed),
	(_vel select 2) + (4.9 * diag_deltaTime)
];};

if (inputAction "MoveBack" == 1) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - diag_deltaTime;
_speed = diag_deltaTime * -5 * _acceleration;
_vel =  [
	(_vel select 0) + (sin (_dir) * _speed),
	(_vel select 1) + (cos (_dir) * _speed),
	(_vel select 2) - (2.5 * diag_deltaTime)
];};

if (_unit getvariable [QGVAR(controlUp),false]) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - diag_deltaTime;
_vel =  [
	(_vel select 0) ,
	(_vel select 1) ,
	((_vel select 2) + (15 * diag_deltaTime * (_ascensionCoef min 1.5))) min 19 // Gravity *should* be 9.8 * diag_deltaTime and this simplifies out to 15 * diag_deltaTime, enough to counteract gravity and then a bit of up
];};


// Perform "air resistance" calculation - really just a counter-vector to slow player down by the air resistance coefficient every second
private _airResistanceCoef = -0.1 * diag_deltaTime * _resistance;
private _airResistance = _vel vectorMultiply _airResistanceCoef;
_vel = _vel vectorAdd _airResistance;


// Set velocity to the final calculated value
_unit setvelocity _vel;


// Increment heat downward for cooling down
if (_heat > 0) then {_heat = _heat - diag_deltaTime/3};

_pack setvariable [QGVAR(fuelAmount), _fuel];
_pack setVariable [QGVAR(overheat),_heat];


}, 0, [_unit,_acceleration, _resistance,_fuelCoef,_heatCoef,_ascensioncoef,_strafeCoef, _oldfreefall]] call CBA_fnc_addPerFrameHandler;

} else 
{
	//Tag player as not jetpacking
	[_pack] call FUNC(variableSync);
	[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(isJetpacking),false];
	private _source = _unit getVariable [QGVAR(soundSource),objNull];
	deleteVehicle _source;
	playsound3d [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getposASL _unit, 4,1,10]; 
};


if !([GVAR(soundHandle)] call CBA_fnc_removePerFrameHandler) then
{
	GVAR(soundHandle) = [
		{
			_this select 0 params ["_unit"];
			if (isGamePaused) exitWith {};
			private _volume = 3;
			if (!(isTouchingGround _unit or [_unit] call FUNC(isSwimming))) then 
			{
				private _volumecoef = {_unit getVariable [_x, false]} count [QGVAR(controlUp)];
				_volumecoef = _volumecoef + ({inputAction _x == 1} count ["moveBack","TurnLeft","TurnRight","MoveForward"]);
				_volume = 4 + _volume * _volumecoef;
			};
			private _source = _unit getVariable [QGVAR(soundSource),objNull];
			if (isNull _source) then {
			private _source = "#dynamicsound" createVehicle [0,0,0];
			_source attachto [_unit,[0,0,0]];
			_unit setvariable [QGVAR(soundSource),_source];
			};
			[QGVAR(say3dGlobal), [_source,QGVAR(soundLoop)]] call CBA_fnc_globalEvent;
		}, 
		
		0.49, [_unit]] call CBA_fnc_addPerFrameHandler;
};

