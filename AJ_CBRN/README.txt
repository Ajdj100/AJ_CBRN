WELCOME TO AJ's CBRN SCRIPT

V1.0.0

Any questions should be directed towards @Ajdj100#6446 on discord.



QUICKSTART GUIDE:

Make sure to drop the 17th mission guts into your mission file first, then follow these instructions (order doesnt matter, but for your sanity go top to bottom).

editor/mission

	place down an object you want to be the source(center) of the chemical area. give this object a variable name, for example "chemical1"



initPlayerLocal.sqf

	Paste the following lines into your initPLayerLocal.sqf

		chemicalWeap = [[variableName, variableName2, etc.], radius(meters), debug TRUE/FALSE] execVM "scripts\AJ_CBRN\chemicalDamage.sqf";

		chemDetector = [[variableName, variableName2, etc.], radius(meters)] execVM "scripts\AJ_CBRN\chemicalDetector.sqf";

		aceMask = ["EquipMask","Put on Gas Mask","",{execVM "scripts\AJ_CBRN\aceGasmask.sqf"},{true}] call ace_interact_menu_fnc_createAction;
		[player, 1, ["ACE_SelfActions", "ACE_Equipment"], aceMask] call ace_interact_menu_fnc_addActionToObject;


	Now that these lines are in your initPlayerLocal.sqf, fill in the values that you want as explained below.

		Replace "variableName, variableName2, etc." with the variable names of your source objects, seperated by commas. "chemical1,chemical2,chemical3"

		Replace "radius(meters)" with the radius you want your chemical areas to be. For my first op I used 25 meters.
		
		Replace "debug TRUE/FALSE" with "TRUE" or "FALSE". This will toggle debug mode, which shows you what sources are in the mission, and the radius of the nearest one.


description.ext

	To start setting up the script, the following line must be added to the CfgSounds class (found at the bottom of description.ext).

		#include "scripts\AJ_CBRN\config.hpp"

	Upon adding the line, the CfgSounds class should look something like this:

		class CfgSounds
		{
			sounds[] = {};
			class radioJamming
			{
				name = "radioJamming";
				sound[] = {"sounds\jammer.ogg", 7, 1};
				titles[] = {0,""};
			};
	
		#include "scripts\AJ_CBRN\config.hpp"
		};


	That is all that needs to be done in description.ext


That should be everything you need to get started. It all scales from that. Now to get into the deep end...



LIMITATIONS:

	In its infancy, despite seeming somewhat impressive on the player side beacuse "woah chemical weapons cool!", it is extremely limited and has a lot of shortcomings that make it especially difficult to use in a fast paced and dynamic environment.

	
	EQUIPTMENT:
	- Currently only the APR (NATO), and the CBRN Suit (NATO) are default protective clothing.
	- These can be changed in the script, but currently it does not support having multiple options for protective equiptment. Only one facewear and one uniform.
	- This is on the list of things to change, but it is pretty low priority.

	RADIUS:
	- Currently the radius of all chemical areas is set globally, meaning they will all have the same radius. This proves to be very limiting as your chemical weapons scale is limited by the smallest area you wish to apply it to.
	- In future this will be changed such that every zone can have its own radius defined, but for now that will just have to be worked around.

	SPAWNING
	- Currently chemical areas cannot be created during the mission. They are only created on mission start.
	- My personal workaround for this is to create a whole bunch of chemical areas outside of the AO. The radius will follow the object it is created around, so you can move these to where you want them during the mission.
	- This will be changed in the next version of the script, it will become a lot more flexible to use during missions with creating these zones.

	DESPAWNING/DESTROYING
	- Chemical areas will despawn if their origin object (the thing with the variable name) is destroyed.
	- Destruction can be a zeus delete, explosive, or just any other action that will drop the health of the object to 0.
	- Some objects cannot be destroyed outside of zeus deleting them. Test accordingly.
	- Some objects cannot be destroyed by players, and instead will be thrown a short distance by explosives. Test accordingly.

	VEHICLES
	- Currently, vehicles offer no protection from chemical areas.
	- In future this will change, probably along with the changes to protective equiptment, but it's low priority.

	SCALABILITY:
	- The script is very set in how it works. I would describe it as almost entirely hardcoded (meaining you have to actually go into the code to change values).
	- Changing things like the damage amount, type, rate, or changing the protective equiptment items, is moderately difficult and requires some light programming knowledge.
	- In future I will try to clean this up and make it more flexible/easily tweaked to make it more accessible to mission makers, but this will be a process that will take time. 

	