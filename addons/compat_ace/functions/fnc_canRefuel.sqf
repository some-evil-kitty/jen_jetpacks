// Written by : Jenna
//
// determines whether or not player can refuel jetpack using a can
//

#include "script_component.hpp"
params ["_unit"];
items _unit findIf {
	GET_NUMBER(configFile >> "CfgWeapons" >> _x >> QEGVAR(core,isFuelCan),0) == 1
} > -1;