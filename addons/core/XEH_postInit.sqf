#include "script_component.hpp"

addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	[QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
}];

call FUNC(cacheJetpacks);
