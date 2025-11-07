class CfgVehicles
{
	class Man;

    class CAManBase: Man {
        class ACE_Actions {
 //           class ACE_OpenBackpack {
                class GVAR(refuelJetpack) {
                    displayName = "Refuel Jetpack";
                    condition = QUOTE([_player] call FUNC(canRefuel) && [_target] call EFUNC(core,hasJetpack));
                    distance = 2;
                    exceptions[] = {"isNotSwimming"};
                    position = QUOTE((call ace_interaction_fnc_getBackpackPos) vectorAdd [ARR_3(0,0,-0.1)]);
                    insertChildren = QUOTE([ARR_2(_player,_target)] call FUNC(insertRefuelChildren));
                    statement = "";
                    icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\refuel_ca.paa";
                };
   //+         };
        };
        class ACE_SelfActions {
            class ACE_Equipment {  
                class GVAR(refuelParent) {
                    displayName = "Refuel Jetpack";
                    condition = QUOTE([_player] call FUNC(canRefuel));
                    exceptions[] = {};
                    insertChildren = QUOTE([ARR_2(_player,_player)] call FUNC(insertRefuelChildren));
                    statement = "";
					icon = "\A3\ui_f\data\igui\cfg\simpleTasks\types\refuel_ca.paa";
                };
            };
	    };
    };
};
