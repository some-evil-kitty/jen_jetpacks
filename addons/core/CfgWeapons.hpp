class CfgWeapons
{
    class CBA_MiscItem;
    class CBA_MiscItem_ItemInfo;

    class GVAR(refuelItemBase) : CBA_MiscItem
    {
        GVAR(isFuelCan) = 1;
        GVAR(fuelCanSize) = 200;
    };
};