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
            targetState = "Combat";
        };
    };

    class Combat {
        class InForest {
            targetState = "Forest";
        };
        class InOpen {
            targetState = "Open";
        };
        class NearBuildings {
            targetState = "Urban";
        };
    };

    class Forest {
        class ContactIsClose {
            targetState = "MoveAway";
        };
        class ContactIsDead {
            targetState = "Idle";
        };
    };

    class MoveAway {
        class ContactIsMedium {
            targetState = "Forest";
        };
    };

    class Open {
        class ContactIsClose {
            targetState = "FlyCombat";
        };
        class ContactIsNotClose {
            targetState = "GetClose";
        };
    };

    class GetClose {
        class ContactIsClose {
            targetState = "FlyCombat";
        };
    };

    class FlyCombat {
        class ContactIsDead {
            targetState = "Idle";
        };
    };

    class Urban {
        class ContactIsCloseOrMedium {
            targetState = "FindRoof";
        };
        class ContactIsDead {
            targetState = "GetOffRoof";
        };
    };

    class FindRoof {
        class FoundRoof {
            targetState = "LandOnRoof";
        };
    };

    class LandOnRoof {
        class NewContact {
            targetState = "Urban";
        };
    };

    class GetOffRoof {
        class OnGround {
            targetState = "Idle";
        };
    };

};