#include "script_component.hpp"
ADDON = false;

PREP_RECOMPILE_START;
#include "XEH_PREP.hpp"
PREP_RECOMPILE_END;

ADDON = true;


//todo: conversion
[
    "knd_jetpack_alarm_volume", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    "Jetpack alarm volume", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["House Kandosii Aux Mod","Jetpack"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.1, 2, 0.5, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    false, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    "knd_disable_jetpackalarm", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    "Disable Jetpack Alarm", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["House Kandosii Aux Mod","Gadgets"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    false, // data for this setting: [min, max, default, number of shown trailing decimals]
    0, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    "knd_jetpacks_alternateHoverControls", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [
        "Alternate Hover Controls", //Display name
        "Controls whether the 'activate jetpack' button starts with ascension" //Tooltip
    ], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["House Kandosii Aux Mod","Jetpack"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    0, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    "knd_jetpack_fuelColor", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "COLOR", // setting type
    "Jetpack Fuel Color (HUD)", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["House Kandosii Aux Mod","Jetpack"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.7, 0.7, 0, 0.5], // data for this setting: default =  [R,G,B,A]
    false, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    "knd_jetpack_heatColor", // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "COLOR", // setting type
    "Jetpack Heat Color (HUD)", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["House Kandosii Aux Mod","Jetpack"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.7, 0, 0, 0.5], // data for this setting: default =  [R,G,B,A]
    false, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;



