#include "script_component.hpp"

params ["_unit"];
private _speed = (velocity _unit) select 2;
private _height = (getPosVisual _unit) select 2;

(_speed < 0) && { _height > 2 }
