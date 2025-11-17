class CfgWeapons
{
    class EGVAR(core,refuelItemBase);
    class CBA_MiscItem_ItemInfo;
    class GVAR(refuelItemMedium) : EGVAR(core,refuelItemBase)
    {
        displayName = "Jetpack Fuel Container";
        scope = 2;
        model = "\A3\Structures_F\Items\Vessels\CanisterFuel_F.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionsTextures[] = {"a3\structures_f\items\vessels\data\canisterfuel_co.paa"};
        picture = QPATHTOF(tex\fuelcan\preview_co.paa);
        EGVAR(core,fuelCanSize) = 150;
        class iteminfo : CBA_MiscItem_ItemInfo
        {
            mass = 35;
        };
    };
};
