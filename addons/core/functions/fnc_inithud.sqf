// Written by: Jenna
//
//
//
// Handles jetpack HUD creation 
// Example:
// call knd_fnc_jetpackHUD
//

#include "script_component.hpp"


// To show HUD:
QGVAR(HUDLayer) cutRsc [QGVAR(RscHUD), "PLAIN"];
private _display = uiNamespace getVariable QGVAR(RscHUD);
private _jetpackBackgroundGauge = _display displayCtrl 4948;
private _jetpackFuelGauge = _display displayCtrl 4947;
private _jetpackHeatGauge = _display displayCtrl 4946;

_jetpackBackgroundGauge ctrlSetBackgroundColor [0,0,0,0.2];

_handle = [{
    params ["_args","_handle"];
    _args params ["_jetpackFuelGauge","_jetpackHeatGauge","_jetpackBackgroundGauge"];
	if (!([jen_player] call FUNC(hasJetpack)) OR visibleMap OR (jen_player getVariable ["ACE_isUnconscious", false]) OR ((call CBA_fnc_getActiveFeatureCamera) isNotEqualTo "")) exitwith 
	{
		{
			_x ctrlShow false
		} foreach [_jetpackFuelGauge,_jetpackHeatGauge,_jetpackBackgroundGauge]
	};
	{
		_x ctrlShow true
	} foreach [_jetpackFuelGauge,_jetpackHeatGauge,_jetpackBackgroundGauge];

	_jetpackFuelGauge ctrlSetTextColor GVAR(fuelColor);
	_jetpackHeatGauge ctrlSetTextColor GVAR(heatColor);

	private _pack = backpackContainer jen_player;
	private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
	if (isNil {_maxFuel}) then {
		private _fuelCapacity = [configFile >> "CfgVehicles" >> typeOf _pack, QGVAR(fuelCapacity),GVAR(maxFuel)] call BIS_fnc_returnConfigEntry;
		_pack setVariable [QGVAR(tankSize),_fuelCapacity];
	};
	private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];
    private _heat = _pack getVariable [QGVAR(overheat),0];
    _fuel =  ((_fuel/_maxFuel));
    _heat = _heat/GVAR(maxHeat);

	if ((((_heat > 0.85) || _fuel < 0.05) && ((time-GVAR(timeSinceLastBeep)) > 2) && !GVAR(disableAlarm)) && jen_player getVariable [QGVAR(isJetpacking),false]) then {
		GVAR(timeSinceLastBeep) = time;
		playSoundUI [QGVAR(soundWarning),GVAR(alarmVolume)];
	};
	
    _jetpackFuelGauge progressSetPosition _fuel;
    _jetpackHeatGauge progressSetPosition _heat;
}, 0, [_jetpackFuelGauge,_jetpackHeatGauge,_jetpackBackgroundGauge]] call CBA_fnc_addPerFrameHandler;
