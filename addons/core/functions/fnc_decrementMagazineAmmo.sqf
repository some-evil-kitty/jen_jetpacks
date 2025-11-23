#include "..\script_component.hpp"
/*
 * Author: Katalam, Blue, Brett Mayson, johnb43, Heavily adapted by Jenna
 * Handle adjusting a magazine's ammo
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Item <STRING>
 * 2: Original count of magazine <NUMBER>
 *
 * Return Value:
 * Nothing
 *
 * Example:
 * [joe, "jen_jetpacks_compat_ace_fuelMagazine", 2] call jen_jetpacks_core_decrementMagazineAmmo
 *
 * Public: No
 */

params ["_unit", "_magazine", "_magazineToAdjustCount"];

private _containers = [uniformContainer _unit, vestContainer _unit, backpackContainer _unit];

private _container = objNull;
private _magazinesContainer = [];
private _hasDecremented = false;

{
	if _hasDecremented exitWith {};
	_container = _x;

	// Get all magazines of _magazine type
	_magazinesContainer = (magazinesAmmoCargo _container) select {_x select 0 == _magazine};

	// Get the ammo count, filter out magazines with 0 ammo
	_magazinesContainer = (_magazinesContainer apply {_x select 1}) select {_x != 0};

	// If there are none or this container does not contain the intended magazine, skip to the next
	if ((_magazinesContainer isEqualTo []) || (_magazinesContainer find _magazineToAdjustCount == -1)) then {
		continue;
	};

	private _magCount = _magazineToAdjustCount - 1; 

	_container addMagazineAmmoCargo [_magazine, -1, _magazineToAdjustCount];
	if (_magCount > 0) then {
		_container addMagazineAmmoCargo [_magazine, 1, _magCount];
	};

	_hasDecremented = true;

} forEach _containers;
