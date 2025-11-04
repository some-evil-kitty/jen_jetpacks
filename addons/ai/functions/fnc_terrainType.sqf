#include "script_component.hpp"

params ["_unit"];

private _nearHouses = _unit nearObjects ["House", TERRAIN_SEARCH_RADIUS];
private _nearTrees = nearestTerrainObjects [_unit, ["Tree", "Bush"], TERRAIN_SEARCH_RADIUS, false, true];

if (count _nearHouses > 10) exitWith {
    TERRAIN_URBAN 
};
if (count _nearTrees > 100) exitWith {
    TERRAIN_FOREST 
};
TERRAIN_OPEN

