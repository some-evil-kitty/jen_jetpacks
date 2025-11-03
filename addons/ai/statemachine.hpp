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
        class HasTarget {
            condition = QFUNC(hasTarget);
            targetState = "Aim";
        };
        class HasWaypoint {
            condition = QFUNC(hasWaypoint);
            targetState = "MoveTo";
        };
    };

    class MoveTo {
        onState = QFUNC(state_moveTo);
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

    class Aim {
        onState = QFUNC(state_aim);
        class PointedAtTarget {
            condition = QFUNC(pointedAtTarget);
            targetState = "Shoot";
        };
        class HasWaypoint {
            condition = QFUNC(hasWaypoint);
            targetState = "MoveTo";
        };
    };

    class Shoot {
        onState = QFUNC(state_shoot);
        class TargetDead {
            condition = QFUNC(targetDead);
            targetState = "Hover";
        };
        class HasWaypoint {
            condition = QFUNC(hasWaypoint);
            targetState = "MoveTo";
        };
    };
};