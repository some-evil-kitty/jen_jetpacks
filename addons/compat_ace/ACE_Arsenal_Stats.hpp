class ACE_Arsenal_Stats
{
    class statBase;
    class GVAR(fuelTank) : statBase
    {
        scope = 2;
        priority = 0.9;
        stats[] = {QEGVAR(core,fuelCapacity)};
        displayName = "Fuel Capacity";
        tabs[] = {{5}, {}};
        showBar = 1;
        condition = "(getNumber (_this select 1 >> 'jen_jetpacks_core_isJetpack') > 0) && getNumber (_this select 1 >> (_this select 0) select 0) > 0";
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  500],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
    class GVAR(acceleration) : GVAR(fuelTank) 
    {
        displayName = "Acceleration";
        priority = 0.8;
        stats[] = {QEGVAR(core,acceleration)};
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  15],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
    class GVAR(resistance) : GVAR(fuelTank)
    {
        displayName = "Drag";
        priority = 0.7;
        stats[] = {QEGVAR(core,drag)};
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  10],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
    class GVAR(heatCoef) : GVAR(fuelTank)
    {
        displayName = "Heat-up";
        priority = 0.6;
        stats[] = {QEGVAR(core,heatCoef)};
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  15],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
    class GVAR(coolCoef) : GVAR(fuelTank)
    {
        displayName = "Cooling Rating";
        priority = 0.5;
        stats[] = {QEGVAR(core,coolCoef)};
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  15],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
    class GVAR(fuelCoef) : GVAR(fuelTank)
    {
        displayName = "Fuel Consumption";
        priority = 0.4;
        stats[] = {QEGVAR(core,fuelCoef)};
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  15],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
    class GVAR(jumpCoef) : GVAR(fuelTank)
    {
        displayName = "Jump Rating";
        priority = 0.3;
        stats[] = {QEGVAR(core,jumpCoef)};
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  15],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
    class GVAR(strafeCoef) : GVAR(fuelTank)
    {
        displayName = "Strafe Rating";
        priority = 0.3;
        stats[] = {QEGVAR(core,strafeCoef)};
        barStatement = "[(_this select 0) select 0,  _this select 1,  [[0,  15],  [0.01,  1],  false]] call ace_arsenal_fnc_statBarStatement_default";
    };
};
