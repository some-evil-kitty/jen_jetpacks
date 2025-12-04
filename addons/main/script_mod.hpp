#define MAINPREFIX z
#define PREFIX jen_jetpacks

#include "script_version.hpp"

#define VERSION MAJOR.MINOR
#define VERSION_AR MAJOR,MINOR,PATCH,BUILD

#define REQUIRED_VERSION 2.16 // Change this if you want to be compatible with older Arma versions
#define REQUIRED_CBA_VERSION {3,18,3}

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(jen - COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(jen - COMPONENT)
#endif
