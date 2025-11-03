#include "script_component.hpp"

params ["_unit"];

systemChat str vectorMagnitude velocity _unit;
vectorMagnitude velocity _unit < HOVER_THRESHOLD
