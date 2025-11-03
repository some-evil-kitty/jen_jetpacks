#define COMPONENT ai
#include "\z\jen_jetpacks\addons\main\script_mod.hpp"

#define DEBUG_MODE_FULL
#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_AI
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_AI
    #define DEBUG_SETTINGS DEBUG_SETTINGS_AI
#endif

#include "script_macros.hpp"

#include "\z\jen_jetpacks\addons\main\script_macros.hpp"