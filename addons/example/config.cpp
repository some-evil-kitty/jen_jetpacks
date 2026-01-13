#include "script_component.hpp"

// information on this addon specifically
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {"jen_jetpacks_example_mk5jetpack_base", "jen_jetpacks_example_mk5jetpack_nato", "jen_jetpacks_example_mk5jetpack_csat"};
        weapons[] = {"jen_jetpacks_example_refuelitemmedium"};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"jen_jetpacks_core","A3_Weapons_F_Ammoboxes"}; // Include addons from this mod that contain code or assets you depend on. Affects loadorder. Including main as an example here.
        authors[] = {"Jenna", "Also Jenna","Also also Jenna","KJW too maybe"}; // sub array of authors, considered for the specific addon, can be removed or left empty {}
        VERSION_CONFIG;
    };
};


#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"