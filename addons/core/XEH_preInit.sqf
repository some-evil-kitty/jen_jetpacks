#include "script_component.hpp"
ADDON = false;


#include "XEH_PREP.hpp"


ADDON = true;


[
    QGVAR(alarmVolume), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    "Jetpack Alarm Volume", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Feedback"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.1, 2, 0.5, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    false, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(disableAlarm), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [
        "Disable Jetpack Alarm", //Display name
        "" //Tooltip
    ], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Feedback"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    false, // data for this setting: [min, max, default, number of shown trailing decimals]
    0, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(fuelColor), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "COLOR", // setting type
    "Jetpack Fuel Color (HUD)", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Feedback"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.7, 0.7, 0, 0.5], // data for this setting: default =  [R,G,B,A]
    false, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(heatColor), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "COLOR", // setting type
    "Jetpack Heat Color (HUD)", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Feedback"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.7, 0, 0, 0.5], // data for this setting: default =  [R,G,B,A]
    false, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(alternateControls), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [
        "Alternate Ascend Controls", //Display name
        "Controls whether the 'activate jetpack' button starts with ascension" //Tooltip
    ], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Controls"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    0, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(ejectHelper), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [
        "Ejection Helper", //Display name
        "Turns on 'eject' helping" //Tooltip
    ], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Misc"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting: [min, max, default, number of shown trailing decimals]
    0, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(globalHeatCoef), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    ["Global Heat Coefficient","WARNING: May have unintended consequences on jetpack archetype balancing."], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Misc"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.1, 2, 1, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;

[
    QGVAR(globalFuelCoef), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "SLIDER", // setting type
    ["Global Fuel Coefficient","WARNING: May have unintended consequences on jetpack archetype balancing."], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    ["KJW's Jetpacks","Jetpack Misc"], // Pretty name of the category where the setting can be found. Can be stringtable entry.
    [0.1, 2, 1, 1], // data for this setting: [min, max, default, number of shown trailing decimals]
    true, // "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {  
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_fnc_addSetting;


jen_player = objNull;
