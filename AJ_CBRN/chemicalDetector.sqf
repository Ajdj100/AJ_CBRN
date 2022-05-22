/*
Chemical Detector script by Ajdj100
Version 0.1.0

Script which adds functionality to the chemical detector based on proximity to a contamination source

Call this script from initPlayerLocal.sqf (example on line 16).


Parameters:
0: Array of objects - the sources of contamination. (Required)
1: Number - the radius of contamination around the source object(s) in meters. (optional, defaults to 50m)


initPlayerLocal.sqf Example: 
chemDetector = [[Chemical1],250] execVM "chemicalDetector.sqf"; (Creates a contamination zone 250m around the location of the Chemical1 object)
*/

//if not a real gamer, exit
if (!hasInterface) exitwith {};
waituntil {!isnull player};

//Define the variables along with their default values.
_sources = param [0, [objNull], [[objNull]]];		//The source of the contamination zone
_rad = param [1, 50, [0]];							//The radius of the contamination zone

//finds the nearest contamination source to the player
_sourceDist = {
	_source = objNull;
	_closestDist = 1000000;
	{
		if (_x distance player < _closestdist) then {
			_source = _x;
			_closestDist = _x distance player;
		};
	} foreach _sources;
	_source;
};
_source = call _sourceDist;

//start audible alert script
execVM "scripts\AJ_CBRN\chemicalWarning.sqf";

// While the chemical sources are alive, loop the thing
while {alive _source} do
{
	if ("ChemicalDetector_01_watch_F" in (assignedItems player)) then {
		//IGUI display on (whatever that means)
		cutRsc ["RscWeaponChemicalDetector", "PLAIN", 1, false]; 

		threat = (10 - (player distance _source) + _rad)/3 min 9.99 max 0 toFixed 2;

		sleep 0.5;
		private _ui = uiNamespace getVariable ["RscWeaponChemicalDetector", displayNull]; 
		if !(isNull _ui) then { 
			private _obj = _ui displayCtrl 101;     
			_obj ctrlAnimateModel ["Threat_Level_Source", parseNumber threat, true]; 
		};

	};

	if (count _sources > 1) then {
		//Checks if the source objects are alive, if not remove them from _sources. (USEFUL FOR DELETING CHEMICAL SOURCES)
		{
			if (!alive _x AND count _sources > 1) then {_sources = _sources - [_x]};
		} foreach _sources;
	
		//Check for closest source
		_source = call _sourceDist;
	};
};
