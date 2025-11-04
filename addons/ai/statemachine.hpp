class GVAR(fsm_flightManager) {
    list = QGVAR(jetpackUnits);
    skipNull = 1;

    class Ground {
        class RequestToTakeoff {
            condition = QFUNC(canTakeoff);
            events[] = { QGVAR(takeoff) };
            targetState = "FlyStart";
        };
    };

    class FlyStart {
        onStateEntered = QFUNC(state_flyStart_enter);
        onState = QFUNC(state_flyStart);
        class InAir {
            condition = QFUNC(inAir);
            targetState = "Hover";
        };
    };

    class Hover {
        onState = QFUNC(state_hover);
        class RequestToLand {
            condition = QFUNC(canLand);
            events[] = { QGVAR(land) };
            targetState = "Land";
        };
        class HasWaypoint {
            condition = QFUNC(hasWaypoint);
            targetState = "MoveTo";
        };
        class OnGround {
            condition = QUOTE(!(_this call FUNC(inAir)));
            targetState = "Ground";
        };
    };

    class MoveTo {
        onState = QFUNC(state_moveTo);
        onStateLeaving = QFUNC(state_moveTo_leave);
        class AtPosition {
            condition = QFUNC(atPosition);
            targetState = "Hover";
        };
        class OnGround {
            condition = QUOTE(!(_this call FUNC(inAir)));
            targetState = "Ground";
        };
        class RequestToLand {
            condition = QFUNC(canLand);
            events[] = { QGVAR(land) };
            targetState = "Land";
        };
    };

    class Land {
        onStateEntered = QFUNC(state_land_enter);
        onState = QFUNC(state_land);
        class OnGround {
            condition = QUOTE(!(_this call FUNC(inAir)));
            targetState = "Ground";
        };
    };
};

class GVAR(fsm_combatManager) {
    list = QGVAR(jetpackUnits);
    skipNull = 1;

    class Idle {
        class InCombat {
            condition = QFUNC(inCombat);
            targetState = "Combat";
        };
        class InAir {
            condition = QFUNC(inAir);
            targetState = "Land";
        };
        class Disabled {
            condition = QUOTE(!(_unit call FUNC(enabled)));
            targetState = "Land";
        };
    };

    class Disabled {
        class Enabled {
            condition = QFUNC(enabled);
            targetState = "Idle";
        };
    };

    class Land {
        onStateEntered = QFUNC(state_combat_land);
        class OnGround {
            condition = QUOTE(!(_this call FUNC(inAir)));
            targetState = "Idle";
        };
    };

    class Combat {
        class InForest {
            condition = QUOTE(TERRAIN_FOREST == (_this call FUNC(terrainType)));
            targetState = "Forest";
        };
        class InOpen {
            condition = QUOTE(TERRAIN_OPEN == (_this call FUNC(terrainType)));
            targetState = "Open";
        };
        class NearBuildings {
            condition = QUOTE(TERRAIN_URBAN == (_this call FUNC(terrainType)));
            targetState = "Urban";
        };
    };

    class Forest {
        onStateEntered = QFUNC(state_combat_decideTarget);
        class ContactIsClose {
            condition = QUOTE(_this call FUNC(canTakeoff) && { CONTACT_CLOSE == (_this call FUNC(contactDistance)) });
            targetState = "MoveAway";
        };
        class ContactIsDead {
            condition = QUOTE(!(_this call FUNC(inCombat)));
            targetState = "Idle";
        };
    };

    class MoveAway {
        onStateEntered = QFUNC(state_combat_moveAway_enter);
        onState = QFUNC(state_combat_moveAway);
        onStateLeaving = QFUNC(state_combat_moveAway_exit);
        class ContactIsMedium {
            condition = QUOTE(CONTACT_MEDIUM == (_this call FUNC(contactDistance)));
            targetState = "Forest";
        };
    };

    class Open {
        onStateEntered = QFUNC(state_combat_decideTarget);
        class ContactIsClose {
            condition = QUOTE(_this call FUNC(canTakeoff) && { CONTACT_CLOSE == (_this call FUNC(contactDistance)) });
            targetState = "FlyCombat";
        };
        class ContactIsNotClose {
            condition = QUOTE(_this call FUNC(canTakeoff) && { CONTACT_CLOSE != (_this call FUNC(contactDistance)) });
            targetState = "GetClose";
        };
        class ContactIsDead {
            condition = QUOTE(!(_this call FUNC(inCombat)));
            targetState = "Idle";
        };
    };

    class GetClose {
        onStateEntered = QFUNC(state_combat_getClose_enter);
        onState = QFUNC(state_combat_getClose);
        class ContactIsClose {
            condition = QUOTE(CONTACT_CLOSE == (_this call FUNC(contactDistance)));
            targetState = "FlyCombat";
        };
    };

    class FlyCombat {
        onStateEntered = QFUNC(state_combat_fly_enter);
        onState = QFUNC(state_combat_fly);
        class ContactIsDead {
            condition = QUOTE(!(_this call FUNC(inCombat)));
            targetState = "Idle";
        };
        class ContactChanged {
            condition = QFUNC(contactChanged);
            targetState = "Open";
        };
    };

    class Urban {
        onStateEntered = QFUNC(state_combat_decideTarget);
        class ContactIsCloseOrMedium {
            condition = QUOTE(CONTACT_FAR != (_this call FUNC(contactDistance)));
            targetState = "FindRoof";
        };
        class ContactIsDead {
            condition = QUOTE(!(_this call FUNC(inCombat)));
            targetState = "GetOffRoof";
        };
    };

    class FindRoof {
        onStateEntered = QFUNC(state_combat_findRoof);
        class FoundRoof {
            condition = QFUNC(foundRoof);
            targetState = "LandOnRoof";
        };
        class DidNotFindRoof {
            condition = QUOTE(!(_this call FUNC(foundRoof)));
            targetState = "FlyCombat";
        };
    };

    class LandOnRoof {
        onStateEntered = QFUNC(state_combat_landOnRoof_enter);
        onState = QFUNC(state_combat_landOnRoof);
        class NewContact {
            condition = QUOTE(_this call FUNC(contactChanged) || { _this call FUNC(shouldRefresh) });
            targetState = "Urban";
        };
    };

    class GetOffRoof {
        onStateEntered = QFUNC(state_combat_getOffRoof_enter);
        onState = QFUNC(state_combat_getOffRoof);
        class OnGround {
            condition = QUOTE(!(_this call FUNC(inAir)));
            targetState = "Idle";
        };
    };

    class FlyCombatUrban: FlyCombat {
        class ContactChanged: ContactChanged {
            condition = QUOTE(_this call FUNC(contactChanged) || { _this call FUNC(shouldRefresh) });
            targetState = "Urban";
        };
    };

};