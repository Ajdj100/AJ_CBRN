/*
Chemical Warfare script by Ajdj100
Version 0.1.1

Simple script which will simulates chemical warfare by damaging players who are within a certain distance to a given object.

Call this script from initPlayerLocal.sqf (example on line 18).

Special thanks to Asherion and Rebel for their TFAR Jammer script which I reverse engineered to create this with.


Parameters:
0: Array of objects - the sources of contamination. (Required)
1: Number - the radius of contamination around the source object(s) in meters. (optional, defaults to 50m)
2: Bool - Debug mode (shows nearest contamination radius on map). (Optional, defaults to FALSE)

initPlayerLocal.sqf Example: 
chemWeapon = [[Chemical1],250] execVM "chemicalDamage.sqf"; (Creates a contamination zone 250m around the location of the Chemical1 object)
*/

if (!hasInterface) exitwith {};
waituntil {!isnull player};

//Define the variables along with their default values.
_sources = param [0, [objNull], [[objNull]]];		//The source of the contamination zone
_rad = param [1, 50, [0]];							//The radius of the contamination zone
_debug = param [2, false, [true]];					//Debug mode toggle

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

// While the chemical sources are alive, loop the thing
while {alive _source} do
{
    // Set variables
    _dist = player distance _source;

	//if the player is within the contamination radius
    if (_dist < _rad) then {
		//if they are wearing goggles
		if (goggles player == "G_AirPurifyingRespirator_01_F") then {

			//delay the damage
			sleep 5.0;

			//if they are not wearing CBRN suit
			if (!(uniform player == "U_B_CBRN_Suit_01_MTP_F")) then {

				//deal the damage
				_limbSelection = selectRandom ["body","head","hand_r","hand_l","leg_r","leg_l"];
				[player, 0.2, _limbSelection, "vehiclecrash"] call ace_medical_fnc_addDamageToUnit;	
			};

		//if they have no protective gear
		} else {
			//deal the damage
			_limbSelection = selectRandom ["body","head","hand_r","hand_l","leg_r","leg_l"];
			[player, 0.2, _limbSelection, "vehiclecrash"] call ace_medical_fnc_addDamageToUnit;	

			//deal it again for extra speedy killing
			_limbSelection = selectRandom ["body","head","hand_r","hand_l","leg_r","leg_l"];
			[player, 0.2, _limbSelection, "vehiclecrash"] call ace_medical_fnc_addDamageToUnit;	
		};
	};
	
    // Debug chat and marker.
	if (_debug) then {
		deletemarkerLocal "CIS_DebugMarker";
		deletemarkerLocal "CIS_DebugMarker2";
		//Area marker
		_debugMarker = createmarkerLocal ["CIS_DebugMarker", position _source];
		_debugMarker setMarkerShapeLocal "ELLIPSE";
		_debugMarker setMarkerSizeLocal [_rad, _rad];
		
		//Position Marker
		_debugMarker2 = createmarkerLocal ["CIS_DebugMarker2", position _source];
		_debugMarker2 setMarkerShapeLocal "ICON";
		_debugMarker2 setMarkerTypeLocal "mil_dot";
		_debugMarker2 setMarkerTextLocal format ["%1", _source];
		
		systemChat format ["Active Zone: %1, Zones: %2",_source, _sources];
	};

    // Sleep 5 seconds before running again
    sleep 5.0;
	//If there are more than 1 chemical sources.
	if (count _sources > 1) then {
		//Checks if the source objects are alive, if not remove them from _sources. (USEFUL FOR DELETING CHEMICAL SOURCES)
		{
			if (!alive _x AND count _sources > 1) then {_sources = _sources - [_x]};
		} foreach _sources;
	
		//Check for closest source
		_source = call _sourceDist;
	};
};
