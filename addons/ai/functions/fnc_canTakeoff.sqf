#include "script_component.hpp"

params ["_unit"];

private _testPos = eyePos _unit;
private _notBelowThings = (lineIntersectsSurfaces [_testPos, _testPos vectorAdd [0, 0, GVAR(defaultHoverHeight)], _unit]) isEqualTo [];
_notBelowThings
