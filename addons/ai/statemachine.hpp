class GVAR(fsm_flightManager) {
    list = QGVAR(jetpackUnits);
    skipNull = 1;

    class Ground {
        class RequestToTakeoff {
            targetState = "FlyStart";
        };
    };

    class FlyStart {
        class InAir {
            targetState = "Hover";
        };
    };

    class Hover {
        class RequestToLand {
            targetState = "Land";
        };
        class HasTarget {
            targetState = "Aim";
        };
        class HasWaypoint {
            targetState = "MoveTo";
        };
    };

    class MoveTo {
        class AtPosition {
            targetState = "Hover";
        };
    };

    class Land {
        class OnGround {
            targetState = "Ground";
        };
    };

    class Aim {
        class PointedAtTarget {
            targetState = "Shoot";
        };
        class HasWaypoint {
            targetState = "MoveTo";
        };
    };

    class Shoot {
        class TargetDead {
            targetState = "Hover";
        };
        class HasWaypoint {
            targetState = "MoveTo";
        };
    };
};