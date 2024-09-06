#include "script_component.hpp"

// information on this addon specifically
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_common","cba_events","cba_settings"}; // include external addons here that your whole mod depends on and have your other addons require this one.
        authors[] = {}; // sub array of authors, considered for the specific addon

        VERSION_CONFIG;
    };
};

// information on the whole mod (only needed once)
class CfgMods {
    class PREFIX {
        dir = "@Jen_Jetpacks";
        name = "KJW's Jetpacks";

        picture         = "title_co.paa";       // Picture displayed from the expansions menu. Optimal size is 2048x1024
        hideName        = "false";              // Hide the extension name in main menu and extension menu
        hidePicture     = "false";              // Hide the extension picture in the extension menu

        action          = "https://discord.gg/jw2GCgN2Yr"; // Website URL, that can accessed from the expansions menu 
        actionName      = "Join the discord!";              // label of button/tooltip in extension menu
        description     = "KJW's Jetpacks"; // Probably in context with action

        // Color used for DLC stripes and backgrounds (RGBA)
        dlcColor[] = {1, 0.0, 0.86, 1};
    };
};
// Configs go here
