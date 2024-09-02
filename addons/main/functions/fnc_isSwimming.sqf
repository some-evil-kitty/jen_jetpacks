//Author: das attorney, Jonpas
//License: GPL 3 (from ACE3)
//
//

params [["_unit", objNull, [objNull]]];

((animationState _unit) select [1, 3]) in ["bdv","bsw","dve","sdv","ssw","swm"]