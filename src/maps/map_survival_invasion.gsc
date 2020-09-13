#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include pix\_common_scripts;

init_invasion()
{
    //Check if we could use some of those strings
    precachestring( &"SO_DEFENSE_INVASION_OBJ_REGULAR" );
	precachestring( &"SO_DEFENSE_INVASION_OBJ_HARDENED" );
	precachestring( &"SO_DEFENSE_INVASION_OBJ_VETERAN" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_1" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_2" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_3" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_4" );
	precachestring( &"SO_DEFENSE_INVASION_WAVE_5" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_20" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_30" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_30_SKILLED" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_40" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_40_SKILLED" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_HELLFIRE" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_BTR80" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_HELI" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_HELIS" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_BLANK" );
	precachestring( &"SO_DEFENSE_INVASION_ALERT_COMING" );
	precachestring( &"SO_DEFENSE_INVASION_HUNTERS" );
	precachestring( &"SO_DEFENSE_INVASION_BTR80" );
	precachestring( &"SO_DEFENSE_INVASION_HELICOPTERS" );
	precachestring( &"SO_DEFENSE_INVASION_UAV_SPOTTED" );
	precachestring( &"SO_DEFENSE_INVASION_UAV_TARGETTING" );
	precachestring( &"SO_DEFENSE_INVASION_KILLS_TURRET" );
	precachestring( &"SO_DEFENSE_INVASION_KILLS_BTR80" );
	precachestring( &"SO_DEFENSE_INVASION_KILLS_HELI" );


	//ORIGINAL
    precacheItem("smoke_grenade_american");
	precacheItem("remote_missile_not_player_invasion");
	precacheModel("weapon_stinger_obj");
	precacheModel("weapon_uav_control_unit_obj");
	precacheItem("flash_grenade");
	precacheItem("zippy_rockets");
	precacheItem("stinger_speedy");
	maps\invasion_precache::main();
	maps\invasion_fx::main();
	maps\createart\invasion_art::main();
	maps\_attack_heli::preLoad();
    default_start(::start_survival_invasion);
	maps\_load::main();
	thread maps\invasion_amb::main();
	maps\invasion_anim::main_anim();
	//ORIGINAL end

    //UAV
	maps\_remotemissile::init();
	/*level.uav = spawn_vehicle_from_targetname_and_drive("uav");
	level.uav playLoopSound("uav_engine_loop");
	level.uavRig = spawn("script_model",level.uav.origin);
	level.uavRig setmodel("tag_origin");
	thread UAVRigAiming();*/


	//--- IW4SP SURVIVAL ---

	//DEV
	/#
	level.player thread pix\_dev::_init_dev_tool();
	#/

	//minimap & compass
	minimap_setup("compass_map_invasion");
	
	//Setup Survival
	//init_IW4SP_Survival_setup();

	//--- IW4SP SURVIVAL END ---
}


start_survival_invasion()
{
    //Open doors
	diner_back_door = getEnt("diner_back_door","targetname");
	diner_back_door rotateYaw(85,.3);
	diner_back_door playSound("diner_backdoor_slams_open");
	diner_back_door connectPaths();
	nates_meat_locker_door = getEnt("nates_meat_locker_door","targetname");
	nates_meat_locker_door_model = getEnt(nates_meat_locker_door.target,"targetname");
	nates_meat_locker_door_model linkTo(nates_meat_locker_door);
	nates_meat_locker_door rotateYaw(-82,.1,0,0);
	nates_meat_locker_door connectPaths();
	BT_locker_door = getEnt("BT_locker_door","targetname");
	BT_locker_door rotateYaw(-172,.1,0,0);
	BT_locker_door connectPaths();
	
	//Remove ladder clips that are there to help the player in SP.
	ladder_clip = getEnt("nates_kitchen_ladder_clip","targetname");
	ladder_clip delete();
	ladder_clip = getEnt("bt_ktichen_ladder_clip","targetname");
	ladder_clip delete();

	//Remove ladders entirely
	ladder_ents = getEntArray("inv_ladders","script_noteworthy");
	foreach(ent in ladder_ents)
	{
		ent delete();
	}
	ladder_ents = getEntArray("inv_ladders_pathblocker","script_noteworthy");
	foreach(ent in ladder_ents)
	{
		ent disconnectPaths();
	}
	
	//Remove the Predator Control Unit
	ent = getEnt("predator_drone_control","targetname");
	ent delete();

	/*
	//Remove Refill Ammo
	rammos = getEntArray("ammo_cache","targetname");
	foreach(ammo in rammos)
	{
		ammo delete();
	}
	*/

	//Remove Claymore pickup triggers
	claymores = getEntArray("script_model_pickup_claymore","classname");
	foreach(claymore in claymores)
	{
		claymore delete();
	}

	//Remove placed weapons
	sentries = getEntArray("misc_turret","classname");
	foreach(sentry in sentries)
	{
		sentry delete();
	}
	stingers = getEntArray("weapon_stinger","classname");
	foreach(stinger in stingers)
	{
		stinger delete();
	}
	level thread removePlacedWeapons();
}