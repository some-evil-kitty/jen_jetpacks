class CfgVehicles
{
    class Bag_Base;

    class GVAR(mk5Jetpack_base) : Bag_Base
    {
        displayName = "Mk. 5 P.A.L.S.";
        scope = 2;
        descriptionShort = "Mk. 5 Personal Aerial Lift System";
        picture = QPATHTOF(tex\mk5\preview_co.paa);
        EGVAR(core,isJetpack) = 1;
        PRESET_MEDIUM;
        model = QPATHTOF(mdl\mk5.p3d);
        hiddenSelections[] = {"camo1"};
        hiddenSelectionsTextures[] = {
            QPATHTOF(tex\mk5\camo1_co.paa)
        };
        EGVAR(core,particlePoints)[] = {"effect_Left","effect_Right"};
        mass = 150;
        maximumLoad = 10;
    };

    class GVAR(mk5Jetpack_nato) : GVAR(mk5Jetpack_base)
    {
        displayName = "Mk. 5 P.A.L.S. (NATO)";
        picture = QPATHTOF(tex\mk5\ctrg\preview_co.paa);
        PRESET_JUMPER;
        hiddenSelectionsTextures[] = {
            QPATHTOF(tex\mk5\ctrg\camo1_co.paa)
        };
    };

    class GVAR(mk5Jetpack_csat) : GVAR(mk5Jetpack_nato)
    {
        displayName = "Mk. 5 P.A.L.S. (CSAT)";
        picture = QPATHTOF(tex\mk5\csat\preview_co.paa);
        PRESET_FAST;
        hiddenSelectionsTextures[] = {
            QPATHTOF(tex\mk5\csat\camo1_co.paa)
        };
    };
};