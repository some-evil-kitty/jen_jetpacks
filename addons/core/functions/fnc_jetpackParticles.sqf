// Written by Jenna
//
// Handles jetpack particles
//
// 
#include "script_component.hpp"
if !(hasInterface) exitWith {};
params ["_unit","_activate"];
private _pack = backpackContainer _unit;
private _config = (configOf _pack);
private _defaultPoints = ["effect_left","effect_right"];
private _particlePoints = GET_ARRAY(_config >> QGVAR(particlePoints),_defaultPoints);

private _existingParticles = _unit getVariable [QGVAR(particles),[]];
{
	deleteVehicle _x;
} forEach _existingParticles;
if !_activate exitWith {};
private _newParticles = [];
{
	_firepos = _pack selectionPosition [_x,"Memory"];
	if (_firepos isEqualTo [0,0,0]) exitWith {
		private _jetsparks = "#particlesource" createVehicleLocal (getPosATL _pack);
		private _jetsmoke = "#particlesource" createVehicleLocal (getPosATL _pack);
		_jetsparks setParticleClass "FireSparks";
		_jetsparks attachTo [_unit, [-0.2,0,0], "Aimpoint",true];
		_jetsparks setDropInterval 0.01;
		_jetsmoke setParticleClass "AvionicsSmoke";
		_jetsmoke setDropInterval 0.01;
		_jetsmoke attachTo [_unit, [-0.2,0,0], "Aimpoint",true];
		_newParticles = [_jetsparks,_jetsmoke];
		_unit setVariable [QGVAR(particles),_newParticles];
	};
	private _jetfire = "#particlesource" createVehicleLocal (getPosATL _pack);
	_newParticles pushBack _jetfire;
	private _jetsmoke = "#particlesource" createVehicleLocal (getPosATL _pack);
	_newParticles pushBack _jetsmoke;
	_fireoffset = (_firepos vectorDiff [-0.009,-0.008,0.356]);
	_jetsmoke attachTo [_unit, _fireoffset, "Spine3",true];
	_jetfire attachTo [_unit, _fireoffset, "Spine3",true];
	_jetsmoke setParticleClass "AvionicsSmoke";
	_jetfire setParticleClass "Flare2";
	_jetfire setDropInterval 0.005;
} forEach _particlePoints;

_unit setVariable [QGVAR(particles),_newParticles];
