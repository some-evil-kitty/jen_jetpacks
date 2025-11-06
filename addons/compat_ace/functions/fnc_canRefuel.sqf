// Written by : Jenna
//
// determines whether or not player can refuel jetpack using a can
//

#include "script_component.hpp"
params ["_unit"];

_itemsToSearch = [];

{
	_itemsToSearch pushBackUnique [_x, "CfgWeapons"];
} forEach items _unit;

{
	_itemsToSearch pushBackUnique [_x, "CfgMagazines"];
} forEach magazines _unit; 

_itemsToSearch findIf {
	_x params ["_item", "_configParent"];
	GET_NUMBER(configFile >> _configParent >> _item >> QEGVAR(core,isFuelCan),0) == 1;
} > -1;
