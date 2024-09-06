// Written by : Jenna
//
// determines whether or not player can refuel jetpack using a can
//

#include "script_component.hpp"
params ["_unit"];
items _unit findif {GET_NUMBER(configfile >> "CfgWeapons" >> _x >> QEGVAR(isFuelCan),0) == 1} > -1;