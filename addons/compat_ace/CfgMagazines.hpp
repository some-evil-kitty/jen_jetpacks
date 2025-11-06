class CfgMagazines
{
    class CA_Magazine;

    class GVAR(magazineCan): CA_Magazine
    {
        displayName = "Fuel Can Magazine";
        count = 2;
        scope = 2;
        EGVAR(core,isFuelCan) = 1;
        EGVAR(core,fuelCanSize) = 200;
        picture = "\A3\ui_f\data\igui\cfg\simpleTasks\types\refuel_ca.paa";
    };
};
