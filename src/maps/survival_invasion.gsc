#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include pix\_common_scripts;

//map so_defense_invasion & so_killspree_invasion


init_invasion()
{
    //Check if we could use some of those strings
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
	if(cointoss())//cointoss music selection
	{
		thread music_loop("so_defense_invasion_music",191);
	}
	else
	{
		thread music_loop("so_killspree_invasion_music",124);
	}
	//ORIGINAL end

    //UAV
	maps\_remotemissile::init();
	level.uav = spawn_vehicle_from_targetname_and_drive("uav");
	level.uav playLoopSound("uav_engine_loop");
	level.uavRig = spawn("script_model",level.uav.origin);
	level.uavRig setmodel("tag_origin");
	level thread UAVRigAiming();

	//Heli
	level.attackheliRange = 7000;

	//BTR80
	level thread btr80_level_init();


	//--- IW4SP SURVIVAL ---

	//DEV
	if(isDeveloperMode())
	{
		level.player thread pix\_dev::_init_dev_tool();
	}

	//minimap & compass
	minimap_setup("compass_map_invasion");
	
	//Setup Survival
	init_IW4SP_Survival_setup();
	
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

init_IW4SP_Survival_setup()
{
	//Intro Type for Players
	level.players_intro = "default_zoom_in";

	//Player Spawnpoints & Start Weapon
	level pix\player\_player::addPlayers((-4215.57,-5834.71,2310.13),(0,88.3502,0),(-4454.06,-5827.83,2310.13),(0,88.3502,0),"beretta");

	//Wave Scheme
	level.wave_scheme = "default";

	//Bot Spawnpoints
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (3799.49,-5861.3,2306.89);
	level.bot_spawnPoints[1] = (-4881.62,-2047.27,2314.79);
	level.bot_spawnPoints[2] = (4676.17,-2774.83,2310.13);

	//Bot Spawners
	pix\bot\_bot_spawner::addSpawner(43,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot_spawner::addSpawner(56,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot_spawner::addSpawner(142,"default",level.bot_spawnPoints[0]);//lmg
	pix\bot\_bot_spawner::addSpawner(133,"default",level.bot_spawnPoints[0]);//rpg
	pix\bot\_bot_spawner::addSpawner(1,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot_spawner::addSpawner(8,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot_spawner::addSpawner(28,"default",level.bot_spawnPoints[1]);//lmg
	pix\bot\_bot_spawner::addSpawner(25,"default",level.bot_spawnPoints[1]);//rpg
	pix\bot\_bot_spawner::addSpawner(3,"default",level.bot_spawnPoints[2]);//ar
	pix\bot\_bot_spawner::addSpawner(20,"default",level.bot_spawnPoints[2]);//shotgun
	pix\bot\_bot_spawner::addSpawner(64,"default",level.bot_spawnPoints[2]);//lmg
	pix\bot\_bot_spawner::addSpawner(30,"default",level.bot_spawnPoints[2]);//rpg
	pix\bot\_bot_spawner::addSpawner(44,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//ar
	pix\bot\_bot_spawner::addSpawner(68,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//shotgun
	pix\bot\_bot_spawner::addSpawner(81,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//lmg
	pix\bot\_bot_spawner::addSpawner(65,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//rpg
	pix\bot\_bot_spawner::addSpawner(45,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//ar
	pix\bot\_bot_spawner::addSpawner(60,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//shotgun
	pix\bot\_bot_spawner::addSpawner(152,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//lmg
	pix\bot\_bot_spawner::addSpawner(82,"default",level.bot_spawnPoints[randomIntRange(0,2)]);//rpg

	//Weapon Shop
	level.WeaponsSetup_func = maps\survival_invasion::setUpWeaponShop_Weapons;
	pix\shop\_shop_weapon::addWeaponShop((-704.662,-1038.22,2356.12),(0,90,0),"weapon_uav_control_unit","waypoint_ammo");

	//Support Shop
	pix\shop\_shop_support::addSupportShop((482.177,-5602.88,2358.13),(0,-90,0),"weapon_uav_control_unit","hud_burningcaricon");

	//Map Leaving Triggers
	pix\map\_trigger_map_leave::addMapLeavingTrigger((-4506.39,-5559.04,2310.13),300);//TESTTTTT



	level thread pix\_main::start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47",1000,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_digital_acog",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_EOTECH","ak47_digital_eotech",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_digital_grenadier",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_digital_reflex",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_SHOTGUN","ak47_shotgun",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_BERETTA","beretta",400,"pistol");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_CHEYTAC","cheytac",1000,"sniper");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FAL_ACOG","fal_acog",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FAL_SHOTGUN","fal_shotgun",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_SEMTEX","semtex_grenade",600,"equipment");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_M240","m240",2000,"lmg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_M240_ACOG","m240_acog",2200,"lmg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_M240_REDDOT","m240_reflex",2200,"lmg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_M4","m4_grunt",1000,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_RPD","rpd",2000,"lmg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_RPD_ACOG","rpd_acog",2200,"lmg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_RPD_REDDOT","rpd_reflex",2200,"lmg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_RPG","rpg_player",2000,"equipment");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_SCAR_ACOG","scar_h_acog",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_SCAR_GL","scar_h_grenadier",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_SCAR_REDDOT","scar_h_reflex",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_SCAR_SHOTGUN","scar_h_shotgun",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_SCAR_THERMAL","scar_h_thermal",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_STRIKER_REDDOT","striker_reflex",900,"shotgun");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_digital_acog",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_EOTECH","tavor_digital_eotech",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_REDDOT","tavor_reflex",1200,"assault_rifle");
}










UAVRigAiming()
{
	level.uav endon("death");
	for(;;)
	{
		if (IsDefined(level.uavTargetEnt))
		{
			targetPos = level.uavTargetEnt.origin;
		}
		else if(IsDefined(level.uavTargetPos))
		{
			targetPos = level.uavTargetPos;
		}
		else
		{
			targetpos = (-553.753,-2970,2369.84);
		}
		angles = VectorToAngles(targetPos-level.uav.origin);
		level.uavRig MoveTo(level.uav.origin,0.10,0,0);
		level.uavRig RotateTo(ANGLES,0.10,0,0);
		wait 0.05;
	}
}


btr80_level_init()
{
	if(isDefined(level.btr_init))
	{
		return;
	}
	level.btr_init = true;
	level.btr80_count = 0;
	if(!isDefined(level.btr_min_fighting_range))
	{
		level.btr_min_fighting_range = 400;
	}
	if(!isDefined(level.btr_max_fighting_range))
	{
		level.btr_max_fighting_range = 2400;
	}
	if(!isDefined(level.btr_target_fov))
	{
		level.btr_target_fov = cos(50);
	}
	level.btr80_building_checks = getEntArray("trigger_multiple_flag_set_touching","classname");
	for(i=level.btr80_building_checks.size-1;i>=0;i--)
	{
		building = level.btr80_building_checks[i];
		if(!isDefined(building.script_flag))
		{
			level.btr80_building_checks[i] = undefined;
			continue;
		}
		switch(building.script_flag)
		{
			case "player_inside_nates":
			case "player_in_burgertown":
			case "player_in_diner":
				// Do nothing, keep in the list.
				break;
			default:
				level.btr80_building_checks[i] = undefined;
				break;
		}
	}
}