#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;


/*
	TODO:
			WAVE SYSTEM & WAVE SCHEME --- Bot amount stuff to make wave setups easy to add/remove --- WAVE SCHEMES ARE CURRENTLY TEMPORARY
*/

/*
	LAST WORKED ON:
*/

/*
	PAUSED:
			Map Leaving Triggers ----- wait for the right map to do it
*/


/*
	KOWN BUGS:
*/

start_IW4SP_Survival()
{
	//level.iw4sp_survival_version = 2.0;
	objective_add(0,"current", "Survive as long as possible!");
	objective_add(1,"current", "IW4SP Survival by P!X[VERSION: ^1DEVELOPER^7]");//tmp
	//objective_add(1,"current", "IW4SP Survival by P!X[VERSION: " + level.iw4sp_survival_version+ "]");

	//Precache Player Hud Line
	precacheShader("line_horizontal");

	//Precache Shop Menu Shaders
	precacheShader("mw2_popup_bg_fogscroll");
	precacheShader("mockup_bg_glow");
	precacheShader("mw2_popup_bg_fogstencil");
	precacheShader("xpbar_stencilbase");
	precacheShader("menu_setting_selection_bar");

	//Precache Map Leaving Strings
	precacheString(&"SPECIAL_OPS_ESCAPE_WARNING");
	precacheString(&"SPECIAL_OPS_ESCAPE_SPLASH");

	//Check if Player Spawnpoints & Spawnangles are defined
	if(!isDefined(level.player1_spawnPoint)||!isDefined(level.player1_spawnAngle)||!isDefined(level.player2_spawnPoint)||!isDefined(level.player2_spawnAngle))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ a player spawnpoint is not DEFINED! ------");
		printToConsole("IW4SP_SURVIVAL_ERROR: ------ a player spawnpoint is not DEFINED! ------");
		return;
	}

	//Check if Player Start Weapon is defined --- if not use default weapon
	if(!isDefined(level.startWeapon))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ level.startWeapon is not DEFINED! ---- set to defaultweapon ------");
		level.startWeapon = "defaultweapon";
		printToConsole("IW4SP_SURVIVAL_WARNING: ------ level.startWeapon is not DEFINED! ---- set to defaultweapon ------");
	}

	//Check if Players Intro is defined --- if not use default
	if(!isDefined(level.players_intro))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ level.players_intro is not DEFINED! ---- set to default ------");
		level.players_intro = "default_zoom_in";
		printToConsole("IW4SP_SURVIVAL_WARNING: ------ level.players_intro is not DEFINED! ---- set to default ------");
	}

	//Check if Wave Scheme is defined
	if(!isDefined(level.wave_scheme))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ level.wave_scheme not DEFINED! ------");
		printToConsole("IW4SP_SURVIVAL_ERROR: ------ level.wave_scheme not DEFINED! ------");
		return;
	}

	//Check if a Bot Spawnpoint is defined
	if(!isDefined(level.bot_spawnPoints))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ no bot spawnpoint DEFINED! ------");
		printToConsole("IW4SP_SURVIVAL_ERROR: ------ no bot spawnpoint DEFINED! ------");
		return;
	}

	//Check if a Bot Spawner is defined
	if(!isDefined(level.pix_spawner))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ no bot spawner DEFINED! ------");
		printToConsole("IW4SP_SURVIVAL_ERROR: ------ no bot spawner DEFINED! ------");
		return;
	}

	//Precache Weapon Shop Icon + Model if defined
	if(isDefined(level.shop_info["weapon"].model))
	{
		precacheModel(level.shop_info["weapon"].model);
	}
	if(isDefined(level.shop_info["weapon"].headIcon))
	{
		precacheShader(level.shop_info["weapon"].headIcon);
	}

	//Check if a weaponlist setup is defined --- if not use the default one
	if(!isDefined(level.WeaponsSetup_func))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ level.startWeapon is not DEFINED! ---- set to default_weaponshopSetup ------");
		level.WeaponsSetup_func = pix\shop\_shop_weapon::default_weaponshopSetup;
		printToConsole("IW4SP_SURVIVAL_WARNING: ------ level.startWeapon is not DEFINED! ---- set to default_weaponshopSetup ------");
	}

	//Precache Support Shop Icon + Model if defined
	if(isDefined(level.shop_info["support"].model))
	{
		precacheModel(level.shop_info["support"].model);
	}
	if(isDefined(level.shop_info["support"].headIcon))
	{
		precacheShader(level.shop_info["support"].headIcon);
	}

	//Map Leaving Stuff
	if(isDefined(level.survival_use_so_escape_triggers) && level.survival_use_so_escape_triggers)
	{
		level thread maps\_specialops::enable_escape_warning();
		level thread maps\_specialops::enable_escape_failure();
	}

	//Start Mod Systems
	level thread pix\server\_server::init_server();
	level thread pix\shop\_shop::init_shop();
	level thread pix\player\_player::spawn_players();
}