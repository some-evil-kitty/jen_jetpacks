class CfgVehicles
{
	class Man;

    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {  
                class GVAR(refuelParent) {
                    displayName = "Refuel Jetpack";
                    condition = QFUNC(canRefuel);
                    exceptions[] = {};
                    insertChildren = QFUNC(insertRefuelChildren);
                    statement = "true";
                };
            };
	    };
    };
};