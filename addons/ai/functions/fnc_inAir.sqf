#include "script_component.hpp"

params ["_unit"];
(getPosVisual _unit) select 2 > 0.3
