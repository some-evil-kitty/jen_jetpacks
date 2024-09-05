//todo: convert to jen

class RscBackGround;
class RscProgress;
class RscTitles {
	class GVAR(RscHUD) {
		idd = 46920;
		enableSimulation = 1;
		movingEnable = 0;
		fadeIn = 0;
		fadeOut = 1;
		duration = 10e10;
		onLoad = "uiNamespace setVariable ['jen_jetpacks_core_rscHUD', _this select 0]";
		class controls {
			class Background: RscBackGround {
				idc = 4948;
				x = "profileNamespace getVariable ['IGUI_jen_jetpacks_grid_X',  (((0.85) - 0.125) * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_jen_jetpacks_grid_Y',  (((0.2) + 0.04) * safezoneH + safezoneY)]";
				w = "0.15*safezoneW";
				h = "0.05*safezoneH";
			};
			class Fuel: RscProgress {
				idc = 4947;
				x = "profileNamespace getVariable ['IGUI_jen_jetpacks_grid_X',  (((0.85) - 0.125) * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_jen_jetpacks_grid_Y',  (((0.2) + 0.04) * safezoneH + safezoneY)]";
				w = "0.15*safezoneW";
				h = "0.025*safezoneH";
			};
			class Heat: RscProgress {
				idc = 4946;
				x = "profileNamespace getVariable ['IGUI_jen_jetpacks_grid_X',  (((0.85) - 0.125) * safezoneW + safezoneX)]";
				y = "(profileNamespace getVariable ['IGUI_jen_jetpacks_grid_Y',  (((0.2) + 0.04) * safezoneH + safezoneY)]) + ((0.025) * safezoneH)";// (((0.225) + 0.04) * safezoneH + safezoneY)
				w = "0.15*safezoneW"; 
				h = "0.025*safezoneH";
			};
		};
	};
};
