/*
Script to handle the audio alert for the chemical detector
By Ajdj100

version 0.1.0
*/

if (!hasInterface) exitwith {};
waituntil {!isnull player};


while {true} do {
	if ("ChemicalDetector_01_watch_F" in (assignedItems player)) then {
		if (parseNumber threat > 3.0) then {
			playSound "chemical_alarm";
			sleep 5.0;
		};
	};
	sleep 0.5;
};