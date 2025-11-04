#include "script_component.hpp"

params ["_unit"];

alive (_unit getVariable [QGVAR(combat_target), objNull]) || { (_unit targets [true, CONTACT_MAX_DISTANCE]) isNotEqualTo [] }
