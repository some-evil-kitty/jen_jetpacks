#include "script_component.hpp"

params ["_unit"];
(getPosATLVisual _unit) select 2 > 2
