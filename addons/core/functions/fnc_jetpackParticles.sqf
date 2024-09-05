// Written by Jenna
//
// Handles jetpack particles
//
// 
#include "script_component.hpp"
if !(hasInterface) exitwith {};
params ["_unit","_activate"];
_pack = backpackContainer _unit;

private _existingParticles = _unit getVariable [QGVAR(particles),[]];
{
	deletevehicle _x;
} foreach _existingParticles;
if !_activate exitwith {};

_firepos = _pack selectionPosition ["effect_right","Memory"];
if (_firepos isEqualTo [0,0,0]) exitwith {
	private _jetsparks = "#particlesource" createVehicleLocal (getPosATL _pack);
	private _jetsmoke = "#particlesource" createVehicleLocal (getPosATL _pack);
	_jetsparks setParticleClass "FireSparks";
	_jetsparks attachTo [_unit, [-0.2,0,0], "Aimpoint",true];
	_jetsparks setDropInterval 0.01;
	_jetsmoke setParticleClass "AvionicsSmoke";
	_jetsmoke setDropInterval 0.01;
	_jetsmoke attachTo [_unit, [-0.2,0,0], "Aimpoint",true];
	private _newParticles = [_jetsparks,_jetsmoke];
	_unit setVariable [QGVAR(particles),_newParticles];
};
private _newParticles = [];
private _jetfireright = "#particlesource" createVehicleLocal (getPosATL _pack);
_newParticles pushBack _jetfireright;
private _jetsmokeright = "#particlesource" createVehicleLocal (getPosATL _pack);
_newParticles pushBack _jetsmokeright;
_fireoffset = (_firepos vectorDiff [-0.009,-0.008,0.356]);
_jetsmokeright attachTo [_unit, _fireoffset, "Spine3",true];
_jetfireright attachTo [_unit, _fireoffset, "Spine3",true];
_jetsmokeright setParticleClass "AvionicsSmoke";
_jetfireright setParticleClass "Flare2";
_jetfireright setDropInterval 0.005; 


_firepos = _pack selectionPosition ["effect_left","Memory"];
private _jetfireleft = "#particlesource" createVehicleLocal (getPosATL _pack);
_newParticles pushBack _jetfireleft;
private _jetsmokeleft = "#particlesource" createVehicleLocal (getPosATL _pack);
_newParticles pushBack _jetsmokeleft;
_fireoffset = (_firepos vectorDiff [-0.009,-0.008,0.356]);
_jetsmokeleft attachTo [_unit, _fireoffset, "Spine3",true];
_jetfireleft attachTo [_unit, _fireoffset, "Spine3",true];
_jetsmokeleft setParticleClass "AvionicsSmoke";
_jetfireleft setParticleClass "Flare2";
_jetfireleft setDropInterval 0.005;

_unit setVariable [QGVAR(particles),_newParticles];
