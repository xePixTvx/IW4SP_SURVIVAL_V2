#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_specialops;
#include pix\_common_scripts;

main()
{
	//try to add ambient music

	//ORIGINAL
	default_start(::start_so_hidden);
	setsaveddvar("sm_sunShadowScale","0.7");
	maps\so_hidden_so_ghillies_anim::main();
	maps\so_ghillies_precache::main();
	maps\createart\so_ghillies_art::main();
	maps\so_ghillies_fx::main();
	maps\_load::main();
	thread maps\so_ghillies_amb::main();
	thread maps\_radiation::main();
	//ORIGINAL end
	

	
	//--- IW4SP SURVIVAL ---

	//DEV
	if(isDeveloperMode())
	{
		level.player thread pix\_dev::_init_dev_tool();
	}

	//minimap & compass
	minimap_setup("");
	
	//Setup Survival
	init_IW4SP_Survival_setup();

	//--- IW4SP SURVIVAL END ---
}

start_so_hidden()
{
	remove_church_door();
	level thread block_churchtower_ladder();//blocked cause it confuses the AI
	
	//Remove placed weapons
	level thread removePlacedWeapons();
}

//since im to stupid to find collision stuff im doing it the lazy way
block_churchtower_ladder()
{
	level.church_tower_blocker = spawn("script_model",(-34235.2,-1472.22,308.056));
	for(;;)
	{
		foreach(player in getPlayers())
		{
			if(distance(player.origin,level.church_tower_blocker.origin)<=20)
			{
				player setOrigin((-34156.5,-1442.98,224.125));
				iprintlnBold("Cant go up here!");
				wait 0.05;
			}
		}
		wait 0.05;
	}
}

//Remove church door
remove_church_door()
{
	church_doors = getentarray("church_door_front","targetname");
	foreach(door in church_doors)
	{
		door ConnectPaths();
		door Delete();
	}
}


init_IW4SP_Survival_setup()
{
	//Intro Type for Players
	level.players_intro = "default_zoom_in";

	//Player Spawnpoints & Start Weapon
	level pix\player\_player::addPlayers((-35879.6,-1560.18,211.203),(0,-25.6846,0),(-35819.4,-1433.56,219.505),(0,-24.1465,0),"usp_silencer");

	//Wave Scheme
	level.wave_scheme = "default";

	//Bot Spawnpoints
	level.bot_spawnPoints = [];
	level.bot_spawnPoints[0] = (-33778.3,-7072.9,194.485);
	level.bot_spawnPoints[1] = (-32201.2,-120.428,212.125);

	//Bot Spawners
	pix\bot\_bot_spawner::addSpawner(7,"default",level.bot_spawnPoints[0]);//sniper
	pix\bot\_bot_spawner::addSpawner(21,"default",level.bot_spawnPoints[0]);//shotgun
	pix\bot\_bot_spawner::addSpawner(22,"default",level.bot_spawnPoints[0]);//ar
	pix\bot\_bot_spawner::addSpawner(26,"default",level.bot_spawnPoints[0]);//smg
	pix\bot\_bot_spawner::addSpawner(8,"default",level.bot_spawnPoints[1]);//sniper
	pix\bot\_bot_spawner::addSpawner(35,"default",level.bot_spawnPoints[1]);//shotgun
	pix\bot\_bot_spawner::addSpawner(27,"default",level.bot_spawnPoints[1]);//ar
	pix\bot\_bot_spawner::addSpawner(37,"default",level.bot_spawnPoints[1]);//smg

	//Weapon Shop
	level.WeaponsSetup_func = maps\so_hidden_so_ghillies::setUpWeaponShop_Weapons;
	pix\shop\_shop_weapon::addWeaponShop((-30196.7,48.6782,180.076),(0,50,0),"com_plasticcase_beige_big","waypoint_ammo");

	//Support Shop
	pix\shop\_shop_support::addSupportShop((-28541.7,5015.94,239.125),(0,50,0),"com_plasticcase_beige_big","hud_burningcaricon");


	level thread pix\_main::start_IW4SP_Survival();
}

setUpWeaponShop_Weapons()
{
	level.weaponshop_items = [];
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_ACOG","ak47_digital_acog",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_REDDOT","ak47_digital_reflex",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47","ak47_woodland",1000,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_EOTECH","ak47_woodland_eotech",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_AK47_GP25","ak47_woodland_grenadier",1400,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_DRAGUNOV","dragunov",1000,"sniper");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FAMAS","famas_woodland",1000,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FAMAS_EOTECH","famas_woodland_eotech",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FAMAS_REDDOT","famas_woodland_reflex",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FN2000_ACOG","fn2000_acog",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FN2000_EOTECH","fn2000_eotech",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_FN2000_REDDOT","fn2000_reflex",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_M2FRAGGRENADE","fraggrenade",600,"equipment");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_GLOCK","glock",400,"pistol");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_USP_SILENCER","usp_silencer",400,"pistol");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_BENELLI","m1014",800,"shotgun");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_BENELLI_SILENCER","m1014_silencer",800,"shotgun");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_P90","p90",700,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_P90_ACOG","p90_acog",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_P90_REDDOT","p90_reflex",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_PP2000","pp2000",700,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_PP2000_SILENCER","pp2000_silencer",700,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_STRIKER","striker",800,"shotgun");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_STRIKER_REDDOT","striker_reflex",900,"shotgun");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_STRIKER_SILENCER","striker_woodland_silencer",800,"shotgun");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_MARS","tavor_mars",1000,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_REDDOT","tavor_reflex",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_ACOG","tavor_woodland_acog",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TAVOR_EOTECH","tavor_woodland_eotech",1200,"assault_rifle");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_TMP","tmp",700,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_UMP45_ACOG","ump45_acog",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_UMP45_EOTECH","ump45_eotech",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_UMP45_REDDOT","ump45_reflex",800,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_WA2000","wa2000",1000,"sniper");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_UZI_SILENCER","uzi_silencer",700,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_MP5_SILENCER","mp5_silencer",700,"smg");
	level thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_CHEYTAC_SILENCER","cheytac_silencer",1000,"sniper");
}