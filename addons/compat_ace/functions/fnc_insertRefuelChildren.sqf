// Written by : Jenna
//
// inserts children actions for refueling
//

#include "script_component.hpp"
params ["_unit"];

private _itemsArray = [];
{
	private _config = configFile >> "CfgWeapons" >> _x;
	private _isFuelcan = GET_NUMBER(_config >> QEGVAR(core,isFuelCan),0) == 1;
	if _isFuelcan then 
	{
		private _capacity = GET_NUMBER(_config >> QEGVAR(core,fuelCanSize),200);
		_itemsArray pushBackUnique [_x, _capacity, [false,0]];
	};
} forEach items _unit;

{
	_x params ["_magazine", "_count"];
	private _config = configFile >> "CfgMagazines" >> _magazine;
	private _isFuelcan = GET_NUMBER(_config >> QEGVAR(core,isFuelCan),0) == 1;
	if _isFuelcan then 
	{
		private _capacity = GET_NUMBER(_config >> QEGVAR(core,fuelCanSize),200);
		private _count = GET_NUMBER(_config >> "count",1);
		_itemsArray pushBackUnique [_x, _capacity, [true,_count]];
	};
} forEach magazinesAmmoFull _unit;

private _children = [];

{
	_x params ["_item", "_capacity", "_magazineData"];
	_magazineData params ["_isMagazine","_count"];
	private _childConfig = configFile >> (["CfgWeapons","CfgMagazines"] select _isMagazine) >> _item;
	_children pushBack [[
		format ["jen_jetpacks_refuelChild_%1",_forEachIndex],
		format ["Use %1 (%2)", getText(_childConfig >> "DisplayName", str _count)],
		getText(_childConfig >> "Picture"),
		{
		params ["", "", "_args"];
		_args params ["_unit", "_item", "_capacity", "_magazineData"];
		[_item,_capacity,_magazineData] call EFUNC(core,doRefuel);
		},
		{true},
		{},
		[_unit,_item, _capacity,_magazineData]
	] call ace_interact_menu_fnc_createaction,[],_unit]
} forEach _itemsArray;

_children
