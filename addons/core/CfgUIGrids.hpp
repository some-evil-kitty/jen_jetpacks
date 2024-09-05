class CfgUIGrids {
    class IGUI {
        class Presets {
            class Arma3 {
                class Variables {
                    jen_jetpacks_grid[] = {
                        {
                            "(((0.85) - 0.125) * safezoneW + safezoneX)",
                            "(((0.2) + 0.04) * safezoneH + safezoneY)",
                             "0.15*safezoneW",
                             "0.05*safezoneH"},
                            "(((safezoneW / safezoneH) min 1.2) / 40)",
                            "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"};
                };
            };
        };
        class Variables {
            class jen_jetpacks_grid {
                displayName = "Jetpacks HUD";
                description = "Shows heat + fuel";
                preview = QPATHTOF(tex\ui\jetpack_preview_co.paa);
                saveToProfile[] = {0, 1};
                canResize = 0;
            };
        };
    };
};