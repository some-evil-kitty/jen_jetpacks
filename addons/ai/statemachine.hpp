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