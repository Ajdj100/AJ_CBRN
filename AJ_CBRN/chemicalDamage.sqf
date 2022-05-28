/*
	Chemical Warfare script by Ajdj100
	Version 0.2.1
	
	Simple script which will simulates chemical warfare by damaging players who are within a certain distance to a given object.
	
	call this script from initPlayerLocal.sqf (example on line 18).
	
	Special thanks to Asherion and Rebel for their TFAR Jammer script which I reverse engineered to create this with.
	
	
	Parameters:
	0: Array of objects - the sources of contamination. (Required)
	1: Number - the radius of contamination around the source object(s) in meters. (optional, defaults to 50m)
	2: Bool - Debug mode (shows nearest contamination radius on map). (Optional, defaults to false)
	
	initPlayerLocal.sqf Example: 
	chemWeapon = [[Chemical1], 250] execVM "chemicalDamage.sqf"; (Creates a contamination zone 250m around the location of the Chemical1 object)
*/

if (!hasInterface) exitWith {};
waitUntil {
	!isNull player
};

// Define the variables along with their default values.
_sources = param [0, [objNull], [[objNull]]];// The source of the contamination zone
_rad = param [1, 50, [0]];// The radius of the contamination zone
_debug = param [2, false, [true]];// Debug mode toggle
_allowedGoggles = ["G_AirPurifyingRespirator_01_F"];
_allowedUniforms = ["U_B_CBRN_Suit_01_MTP_F"];
_allowedVehicles = ["rhsusf_m1a2sep1wd_usarmy",
	"rhsusf_m1a2sep1tuskiwd_usarmy",
	"rhsusf_m1a2sep1tuskiiwd_usarmy",
	"rhsusf_m1a2sep2wd_usarmy",
	"RHS_M2A3_BUSKIII_wd",
 	"B_APC_Wheeled_01_cannon_F"
	 ];

// finds the nearest contamination source to the player
_sourceDist = {
	_source = objNull;
	_closestDist = 1000000;
	{
		if (_x distance player < _closestdist) then {
			_source = _x;
			_closestDist = _x distance player;
		};
	} forEach _sources;
	_source;
};
_source = call _sourceDist;

// while the chemical sources are alive, loop the thing
while { alive _source } do {
	_protectionLevel = 0;

	// if the player is in a protected vehicle
	if (typeOf objectParent player in _allowedVehicles) then {
		systemChat "VEHICLE PROTECTION";// debug
		_protectionLevel = 2
	};

	// if they are wearing a mask
	if (goggles player in _allowedGoggles) then {
		// if they are wearing the suit
		if (uniform player in _allowedUniforms) then {
			_protectionLevel = 2;
			systemChat "FULL PROTECTION";// debug
		} else {
			_protectionLevel = 1;
			systemChat "MASK PROTECTION";// debug
		};
	};

	// set variables
	_dist = player distance _source;

	// if the player is within the contamination radius
	if (_dist < _rad) then {
		// if the player is protected from CBRN threats, skip the script.
		if (!(_protectionLevel == 2)) then {
			if (!(_protectionLevel == 1)) then {
				systemChat "MASK PROTECTION";// /DEBUG TAKE THIS OUT LATER

				sleep 5.0;

				_limbSelection = selectRandom ["body", "head", "hand_r", "hand_l", "leg_r", "leg_l"];
				[player, 0.2, _limbSelection, "vehiclecrash"] call ace_medical_fnc_addDamageToUnit;
			} else {
				systemChat "NO PROTECTION";// /DEBUG TAKE THIS OUT LATER

				// deal the damage
				_limbSelection = selectRandom ["body", "head", "hand_r", "hand_l", "leg_r", "leg_l"];
				[player, 0.2, _limbSelection, "vehiclecrash"] call ace_medical_fnc_addDamageToUnit;

				// deal it again for extra speedy killing
				_limbSelection = selectRandom ["body", "head", "hand_r", "hand_l", "leg_r", "leg_l"];
				[player, 0.2, _limbSelection, "vehiclecrash"] call ace_medical_fnc_addDamageToUnit;
			};
		};
	};

	    // Debug chat and marker.
	if (_debug) then {
		deletemarkerLocal "CIS_DebugMarker";
		deletemarkerLocal "CIS_DebugMarker2";
		// Area marker
		_debugMarker = createmarkerLocal ["CIS_DebugMarker", position _source];
		_debugMarker setMarkerShapeLocal "ELLIPSE";
		_debugMarker setMarkerSizeLocal [_rad, _rad];

		// position Marker
		_debugMarker2 = createmarkerLocal ["CIS_DebugMarker2", position _source];
		_debugMarker2 setMarkerShapeLocal "ICON";
		_debugMarker2 setMarkerTypeLocal "mil_dot";
		_debugMarker2 setMarkerTextLocal format ["%1", _source];

		systemChat format ["Active Zone: %1, Zones: %2", _source, _sources];
	};
	    // sleep 5 seconds before running again
	sleep 5.0;
	// if there are more than 1 chemical sources.
	if (count _sources > 1) then {
		// Checks if the source objects are alive, if not remove them from _sources. (USEFUL for DELETING CHEMICAL SOURCES)
		{
			if (!alive _x and count _sources > 1) then {
				_sources = _sources - [_x]
			};
		} forEach _sources;

		// Check for closest source
		_source = call _sourceDist;
	};
};