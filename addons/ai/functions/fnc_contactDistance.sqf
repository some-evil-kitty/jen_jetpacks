#include "script_component.hpp"

params ["_unit"];

private _distance = _unit distance (_unit getVariable [QGVAR(combat_target), objNull]);
if (_distance > CONTACT_FAR_THRESHOLD) exitWith {
    CONTACT_FAR
};
if (_distance > CONTACT_MEDIUM_THRESHOLD) exitWith {
    CONTACT_MEDIUM
};
CONTACT_CLOSE
