#include "script_component.hpp"

params ["_unit"];

_unit setVariable [QEGVAR(core,controlUp), false];
_unit setVariable [QEGVAR(core,controlLeft), false];
_unit setVariable [QEGVAR(core,controlRight), false];
_unit setVariable [QEGVAR(core,controlForward), false];
_unit setVariable [QEGVAR(core,controlBackward), false];
