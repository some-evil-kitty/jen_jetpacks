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

if (!isNull objectParent _unit OR (lifeState _unit == "INCAPACITATED") OR (_unit getVariable ["ace_dragging_isDragging",false]) OR (_unit getVariable ["ace_captives_isHandcuffed",false])) exitWith {}; 

if (_unit getVariable [QGVAR(jetpackDisabled),false]) exitWith {};

if !([_unit] call FUNC(hasJetpack)) exitWith {};

private _pack = backpackContainer _unit;
private _packclass = typeOf _pack;
private _config = configFile >> "CfgVehicles" >> _packclass;

if (_unit getVariable [QGVAR(debounce), false]) exitWith {};

_unit setVariable [QGVAR(debounce), true];

[{
	_this setVariable [QGVAR(debounce), false];
}, _unit, 0.1] call CBA_fnc_waitAndExecute;

private _acceleration = GET_NUMBER(_config >> QGVAR(acceleration),4);
private _resistance = GET_NUMBER(_config >> QGVAR(drag),6);
private _fuelCoef = GET_NUMBER(_config >> QGVAR(fuelCoef),1);
private _heatCoef = GET_NUMBER(_config >> QGVAR(heatCoef),1);
private _coolCoef = GET_NUMBER(_config >> QGVAR(coolCoef),1);
private _strafeCoef = GET_NUMBER(_config >> QGVAR(strafeCoef),1);
private _hoverCoef = GET_NUMBER(_config >> QGVAR(hoverCoef),1);
private _ascensionCoef = GET_NUMBER(_config >> QGVAR(ascensionCoef),1);
private _jumpCoef = GET_NUMBER(_config >> QGVAR(jumpCoef),1);
private _fuelCapacity = GET_NUMBER(_config >> QGVAR(fuelCapacity),GVAR(maxFuel));

// Global multipliers

_fuelCoef = _fuelCoef * GVAR(globalFuelCoef);
_heatCoef = _heatCoef * GVAR(globalheatCoef);

private _externalCondition = true;

//allow external disablement of jetpacks and modification fom custom conditions

private _argsArray = [_unit,_externalCondition,_acceleration,_resistance,_fuelCoef,_heatCoef,_coolCoef,_strafeCoef,_hoverCoef,_ascensionCoef,_jumpCoef,_fuelCapacity];
[QGVAR(jetpackEvent), _argsArray] call CBA_fnc_localEvent;
_argsArray params ["_unit","_externalCondition","_acceleration","_resistance","_fuelCoef","_heatCoef","_coolCoef","_strafeCoef","_hoverCoef","_ascensionCoef","_jumpCoef","_fuelCapacity"];

if !_externalCondition exitWith {};

private _launcher = secondaryWeapon _unit;

if (_launcher isNotEqualTo "") then {
	if !(isNil {CBA_disposable_NormalLaunchers get _launcher}) exitWith {
		_acceleration = _acceleration min 3;
		_resistance = _resistance * 1.1;
		_ascensionCoef = _ascensionCoef  * 0.9;
	};
	_acceleration = _acceleration min 2.5;
	_resistance = _resistance * 1.2;
	_ascensionCoef = _ascensionCoef  * 0.8;
};




_pack setVariable [QGVAR(tankSize),_fuelCapacity];

[_unit,_pack,_coolCoef] call FUNC(addCoolingHandle);

private _pfhHandle = _unit getVariable [QGVAR(mainHandle), -1];
private _source = _unit getVariable [QGVAR(soundSource),objNull];
if (isNull _source) then {
	private _source = "#dynamicsound" createVehicle [0,0,0];
	_source attachTo [_unit,[-0.009,-0.008,0.356],"spine3"];
	_unit setVariable [QGVAR(soundSource),_source];
};

if !([_pfhHandle] call CBA_fnc_removePerFrameHandler) then {


//Reset or set the idle timer 
_unit setVariable [QGVAR(idleTimer),0.2];  


private _oldfreefall = (getUnitFreefallInfo _unit) select 2;

// No freefall!
_unit setUnitFreefallHeight 10000;


// "Jump" when starting out
private _pack = backpackContainer _unit;
private _fuel = _pack getVariable [QGVAR(fuelAmount),_fuelCapacity];

if (isTouchingGround _unit AND _fuel > 0.1 AND !(_pack getVariable [QGVAR(cooldown),false])) then
{
	_pos = getPosASL _unit;
	_pos set [2, (_pos select 2) + 0.05];
	_vel = velocity _unit;
	_vel set [2, (_vel select 2) + 7 * _jumpCoef];
	_unit setPosASL _pos;
	_unit setVelocity _vel;
	playSound3D [QPATHTOF(snd\jetpack_ignition.wss), _unit, false, getPosASL _unit,5,1,30];
};

playSound3D [QPATHTOF(snd\jetpack_loop.wss), _unit, false, getPosASL _unit, 1.5,1,25];
[QGVAR(particleEvent), [_unit,true]] call CBA_fnc_globalEvent;

//Tag player as jetpacking

_unit setVariable [QGVAR(isJetpacking),true];

//Add the PFH
_pfhHandle = [{

// Prevent backlog when paused or alt-tabbed
if (isGamePaused) exitWith {};


_this select 0 params ["_unit","_acceleration","_resistance","_fuelCoef","_heatCoef","_ascensionCoef","_strafeCoef","_hoverCoef","_oldfreefall","_soundSource"];
// Make sure damage is allowed


// Get our variables
private _pack = backpackContainer _unit;
private _heat = _pack getVariable [QGVAR(overheat),0];
private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
if (isNil {_maxFuel}) then {
	private _fuelCapacity = GET_NUMBER(configOf _pack >> QGVAR(fuelCapacity),GVAR(maxFuel));
	_pack setVariable [QGVAR(tankSize),_fuelCapacity];
};
private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];

// Keep uncon people from continuing to fly
if (isNull _pack OR !alive _unit OR !([_unit] call ace_common_fnc_isAwake) or _unit getVariable [QGVAR(jetpackDisabled),false]) exitWith 
{
	[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(isJetpacking),false];
	deleteVehicle _soundSource;
	[_this select 1] call CBA_fnc_removePerFrameHandler;
	[_pack] call FUNC(variableSync);
};


// Make sure you can take damage while on the ground, reset freefall height. It's more performant to do this each frame of the handler than to check. Also, increment the idle timer.
if (isTouchingGround _unit or [_unit] call FUNC(isSwimming) or (!isNull objectParent _unit) OR (lifeState _unit == "INCAPACITATED") OR ((getPosVisual _unit) select 2 < 0.05)) exitWith 
{
	//_unit allowdamage true; 
	_unit setUnitFreefallHeight _oldfreefall;
	if (_heat > 0) then {_heat = _heat - diag_deltaTime};
	if (_heat < GVAR(maxHeat) * 0.7) then { _pack setVariable [QGVAR(cooldown),false]};
	_pack setVariable [QGVAR(overheat),_heat];
	private _idletimer = _unit getVariable [QGVAR(idleTimer),2];
	_idletimer = _idletimer - diag_deltaTime;
	_unit setVariable [QGVAR(idleTimer),_idletimer];
	if (_idletimer < 0) exitWith 
	{
		[_this select 1] call CBA_fnc_removePerFrameHandler;
		deleteVehicle _soundSource;
		[_pack] call FUNC(variableSync);
		[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
		_unit setVariable [QGVAR(isJetpacking),false];
		playSound3D [QPATHTOF(snd\jetpack_off.wss), _unit, false, getPosASL _unit, 5,1,20];
		private _source = _unit getVariable [QGVAR(soundSource),objNull];
		deleteVehicle _source;
	};
};

//Reset the idle timer if you're not on the ground

_unit setVariable [QGVAR(idleTimer),0.2];  


//If player is on cooldown (due to overheating), only do the heat reduction and the fall damage un-fuckery
if (_pack getVariable [QGVAR(cooldown),false] OR _fuel < 0.01) exitWith 
{
	if (_heat > 0) then {_heat = _heat - 2 *diag_deltaTime};
	_pack setVariable [QGVAR(overheat),_heat];
};


// Handle overheating
if ((_unit == jen_player) && { _heat > GVAR(maxHeat) }) exitWith {
	_heat = _heat + 5;
	_pack setVariable [QGVAR(cooldown),true];
	[_this select 1] call CBA_fnc_removePerFrameHandler;
	deleteVehicle _soundSource;
	[_pack] call FUNC(variableSync);
	[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(isJetpacking),false];
	private _source = _unit getVariable [QGVAR(soundSource),objNull];
	deleteVehicle _source;
	playSound3D [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getPosASL _unit, 5,1,10];
};

// Reset overheating if needed (will only be needed in select situations, likely almost never)
 _pack setVariable [QGVAR(cooldown),false];
 

_unit setVariable [QGVAR(acceleration),_acceleration];


// Define our direction and velocity variables
private _dir = direction _unit;
private _vel = velocity _unit;

private _moveUp = false;
private _moveForward = false;
private _moveBackward = false;
private _moveLeft = false;
private _moveRight = false;

if (_unit == jen_player) then {
	_moveUp = _unit getVariable [QGVAR(controlUp), false];
	_moveForward = (inputAction "MoveForward" == 1);
	_moveBackward = (inputAction "MoveBack" == 1);
	_moveLeft = (inputAction "TurnLeft" == 1);
	_moveRight = (inputAction "TurnRight" == 1);
} else {
	_moveUp = _unit getVariable [QGVAR(controlUp), false];
	_moveForward = _unit getVariable [QGVAR(controlForward), false];
	_moveBackward  = _unit getVariable [QGVAR(controlBackward), false];
	_moveLeft = _unit getVariable [QGVAR(controlLeft), false];
	_moveRight = _unit getVariable [QGVAR(controlRight), false];
};

// Check for controls, change velocity variable accordingly. Multiply by previous frametime to normalize for different performance situations.
if (_moveForward) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - (_fuelCoef * diag_deltaTime);
_speed = diag_deltaTime * 5 * _acceleration;
_vel = [
	(_vel select 0) + (sin _dir * _speed),
	(_vel select 1) + (cos _dir * _speed),
	(_vel select 2) + (5 * diag_deltaTime)
];};

if (_moveRight) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - diag_deltaTime;
_speed = diag_deltaTime * 5 * _acceleration * _strafeCoef;
_vel =  [
	(_vel select 0) + (sin (_dir + 90) * _speed),
	(_vel select 1) + (cos (_dir + 90) * _speed),
	(_vel select 2) + (4.9 * diag_deltaTime * _hoverCoef)
];};

if (_moveLeft) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - diag_deltaTime;
_speed = diag_deltaTime * 5 * _acceleration * _strafeCoef;
_vel =  [
	(_vel select 0) + (sin (_dir - 90) * _speed),
	(_vel select 1) + (cos (_dir - 90) * _speed),
	(_vel select 2) + (4.9 * diag_deltaTime * _hoverCoef)
];};

if (_moveBackward) then {
_heat = _heat + (_heatCoef * diag_deltaTime);
_fuel = _fuel - diag_deltaTime;
_speed = diag_deltaTime * -5 * _acceleration;
_vel =  [
	(_vel select 0) + (sin (_dir) * _speed),
	(_vel select 1) + (cos (_dir) * _speed),
	(_vel select 2) - (2.5 * diag_deltaTime)
];};

if (_moveUp) then {
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
_unit setVelocity _vel;


// Increment heat downward for cooling down

if (_unit == jen_player) then {
	if (_heat > 0) then {_heat = _heat - diag_deltaTime/3};

	_pack setVariable [QGVAR(fuelAmount), _fuel];
	_pack setVariable [QGVAR(overheat),_heat];
};

}, 0, [_unit,_acceleration, _resistance,_fuelCoef,_heatCoef,_ascensioncoef,_strafeCoef, _hoverCoef, _oldfreefall, _source]] call CBA_fnc_addPerFrameHandler;
_unit setVariable [QGVAR(mainHandle), _pfhHandle];

_unit setVariable [QGVAR(soundHandle), [
{
	_this select 0 params ["_unit"];
	if (isGamePaused) exitWith {};
	private _source = _unit getVariable [QGVAR(soundSource),objNull];
	if (isNull _source) exitWith {
		(_this select 1) call CBA_fnc_removePerFrameHandler;
	};
	[QGVAR(say3dGlobal), [_source,QGVAR(soundLoop)]] call CBA_fnc_globalEvent;
}, 
0.49, [_unit]] call CBA_fnc_addPerFrameHandler];

} else 
{
	//Tag player as not jetpacking
	[_pack] call FUNC(variableSync);
	[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
	_unit setVariable [QGVAR(isJetpacking),false];
	deleteVehicle _source;
	playSound3D [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getPosASL _unit, 4,1,10]; 
};
