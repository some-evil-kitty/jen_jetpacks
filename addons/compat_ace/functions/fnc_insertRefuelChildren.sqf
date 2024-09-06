// Written by : Jenna
//
// inserts children actions for refueling
//

#include "script_component.hpp"
params ["_unit"];

private _itemsArray = [];
{
	private _config = ConfigFile >> "CfgWeapons" >> _x;
	private _isFuelcan = GET_NUMBER(_config >> QEGVAR(core,isFuelCan),0) == 1;
	if _isFuelcan then 
	{
		private _capacity = GET_NUMBER(_config >> QEGVAR(core,fuelCanSize),200);
		_itemsArray pushBackUnique [_x,_capacity]
	};
} foreach items _unit;

private _children = [];

{
	_x params ["_item","_capacity"];
	private _childConfig = ConfigFile >> "CfgWeapons" >> _item;
	_children pushback [[
		format ["jen_jetpacks_refuelChild_%1",_forEachIndex],
		format ["Use %1", getText(_childConfig >> "DisplayName")],
		getText(_childConfig >> "Picture"),
		{
		params ["","","_args"];
		_args params ["_unit","_item","_capacity"];
		[_item,_capacity] call EFUNC(core,doRefuel);
		},
		{true},
		{},
		[_unit,_item, _capacity]
	] call ace_interact_menu_fnc_createaction,[],_unit]
} foreach _itemsArray;

_children