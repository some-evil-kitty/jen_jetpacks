#include "script_component.hpp"

addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	["knd_jetpackParticleEvent", [_unit,false]] call CBA_fnc_globalEvent;
}];
