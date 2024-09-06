class CfgWeapons
{
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;

    class GVAR(refuelItemBase) : CBA_MiscItem
    {
        scope = 2;
        GVAR(isFuelCan) = 1;
        GVAR(fuelCanSize) = 200;
    };
};