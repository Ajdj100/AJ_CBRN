/*
Gasmask equipping script by Ajdj100
Version 0.1.0

Script to allow players to equip gasmasks via ACE self interact if they are holding one in their inventory. 

PASTE THE FOLLOWING INTO initPlayerLocal.sqf TO INITIALIZE:

aceMask = ["EquipMask","Put on Gas Mask","",{execVM "scripts\aceGasmask.sqf"},{true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "ACE_Equipment"], aceMask] call ace_interact_menu_fnc_addActionToObject;
*/


//if not a player, exit
if (!hasInterface) exitwith {};


_items = items player;

//if the player has a gasmask in their inventory
if ("G_AirPurifyingRespirator_01_F" in _items) then {
	//temporarily stores faceware
	_tempGoggles = goggles player;	

	//Swaps mask with current facewear
	player addGoggles "G_AirPurifyingRespirator_01_F";
	player removeItem "G_AirPurifyingRespirator_01_F";
	player addItem _tempGoggles;

	//destroy temp variable
	_tempGoggles = nil;	

	hint "Added mask";		//debug message
} else {
	hint "No mask in inventory"
};
