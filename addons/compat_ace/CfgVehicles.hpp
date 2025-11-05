class CfgVehicles
{
	class Man;

    class CAManBase: Man {
        class ACE_SelfActions {
            class ACE_Equipment {  
                class GVAR(refuelParent) {
                    displayName = "Refuel Jetpack";
                    condition = QUOTE([_player] call FUNC(canRefuel));
                    exceptions[] = {};
                    insertChildren = QUOTE([_player] call FUNC(insertRefuelChildren));
                    statement = "true";
					icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\refuel_ca.paa";
                };
            };
	    };
    };
};
