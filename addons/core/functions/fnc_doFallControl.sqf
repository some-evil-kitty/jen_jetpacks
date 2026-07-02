// does the falling controlling
// todo: 
// sounding
// testing
// meowing

#include "..\script_component.hpp"
params ["_unit", "_fuelCoef", "_heatCoef"];

GVAR(fallControlHandle) = [{
    params ["_args", "_handle"];
    _args params ["_unit", "_pack", "_fuelCoef", "_heatCoef"];

    // decrement fuel and check for exits first

    if (isNull _pack OR !alive _unit OR !([_unit] call ace_common_fnc_isAwake) or _unit getVariable [QGVAR(jetpackDisabled),false]) exitWith 
    {
        [QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
        _unit setVariable [QGVAR(isJetpacking),false];
        private _soundSource = _unit getVariable [QGVAR(soundSource),objNull];
        deleteVehicle _soundSource;
        [_this select 1] call CBA_fnc_removePerFrameHandler;
        [_pack] call FUNC(variableSync);
        playSound3D [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getPosASL _unit, 5,1,10];
    };

    private _heat = _pack getVariable [QGVAR(overheat),0];
    private _maxFuel = _pack getVariable [QGVAR(tankSize),nil];
    if (isNil {_maxFuel}) then {
        private _fuelCapacity = GET_NUMBER(configOf _pack >> QGVAR(fuelCapacity),GVAR(maxFuel));
        _pack setVariable [QGVAR(tankSize),_fuelCapacity];
    };
    private _fuel = _pack getVariable [QGVAR(fuelAmount),_maxFuel];

    _fuel = _fuel - (_fuelCoef * diag_deltaTime);
    _heat = _heat + (_heatCoef * diag_deltaTime);

    _pack setVariable [QGVAR(overheat), _heat];
    _pack setVariable [QGVAR(fuelAmount), _fuel];

    if (_heat > GVAR(maxHeat)) exitWith {
        _heat = _heat + 5;
        _pack setVariable [QGVAR(cooldown),true];
        [_this select 1] call CBA_fnc_removePerFrameHandler;
        private _soundSource = _unit getVariable [QGVAR(soundSource),objNull];
        deleteVehicle _soundSource;
        [_pack] call FUNC(variableSync);
        [QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
        _unit setVariable [QGVAR(isJetpacking),false];
        playSound3D [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getPosASL _unit, 5,1,10];
    };

    if (_pack getVariable [QGVAR(cooldown),false] OR _fuel < 0.01) exitWith 
    {
        _pack setVariable [QGVAR(overheat),_heat];
    };

    // get variables
    private _velocity = velocity _unit;
    private _height = (getPosVisual _unit)#2;
    private _direction = direction _unit;

    // early exit for landed
    if (_height < 0.05) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
        private _soundSource = _unit getVariable [QGVAR(soundSource),objNull];
        deleteVehicle _soundSource;
        [_pack] call FUNC(variableSync);
        playSound3D [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getPosASL _unit, 5,1,10];
        [QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
    };

    // derived variables
    private _verticalSpeed = _velocity#2;
    private _lateralSpeed = vectorMagnitude [_velocity#0, _velocity#1];
    private _verticalDerivative = (_verticalSpeed ^ 2) / (2 * _height);
    private _projectedTime = (2 * _height) / _verticalSpeed;
    private _lateralDerivative = _lateralSpeed / _projectedTime;

    private _verticalSpeed = _verticalSpeed - ((_verticalDerivative * diag_deltaTime) max 0) + (9.8 * diag_deltaTime);
    private _lateralSpeed = _lateralSpeed - ((_lateralDerivative * diag_deltaTime) max 0);

    _velocity = [
        (sin _direction * _lateralSpeed),
        (cos _direction * _lateralSpeed),
        _verticalSpeed
    ];

    _unit setVelocity _velocity;

    // final sanity check

    if ((vectorMagnitude _velocity) < 0.1) exitWith {
        _handle call CBA_fnc_removePerFrameHandler;
        private _soundSource = _unit getVariable [QGVAR(soundSource),objNull];
        deleteVehicle _soundSource;
        [_pack] call FUNC(variableSync);
        playSound3D [QPATHTOF(snd\jetpack_shutdown.wss), _unit, false, getPosASL _unit, 5,1,10];
        [QGVAR(particleEvent), [_unit,false]] call CBA_fnc_globalEvent;
    };

}, 0, [_unit, backpackContainer _unit, _fuelCoef, _heatCoef]] call CBA_fnc_addPerFrameHandler;
