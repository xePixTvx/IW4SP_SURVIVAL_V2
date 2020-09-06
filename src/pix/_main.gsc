#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

/*
	LAST WORKED ON: 
					WAVE SYSTEM & WAVE SCHEME --- Bot amount stuff to make wave setups easy to add/remove --- WAVE SCHEMES ARE CURRENTLY TEMPORARY

					SHOP MENU
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

	//Check if Player Spawnpoints & Spawnangles are defined
	if(!isDefined(level.player1_spawnPoint)||!isDefined(level.player1_spawnAngle)||!isDefined(level.player2_spawnPoint)||!isDefined(level.player2_spawnAngle))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ a player spawnpoint is not DEFINED! ------");
		return;
	}

	//Check if Player Start Weapon is defined --- if not use default weapon
	if(!isDefined(level.startWeapon))
	{
		iprintln("^3IW4SP_SURVIVAL_WARNING:^7 ------ level.startWeapon is not DEFINED! ---- set to defaultweapon ------");
		level.startWeapon = "defaultweapon";
	}

	//Check if Wave Scheme is defined
	if(!isDefined(level.wave_scheme))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ level.wave_scheme not DEFINED! ------");
		return;
	}

	//Check if a Bot Spawnpoint is defined
	if(!isDefined(level.bot_spawnPoints))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ no bot spawnpoint DEFINED! ------");
		return;
	}

	//Check if a Bot Spawner is defined
	if(!isDefined(level.pix_spawner))
	{
		iprintln("^1IW4SP_SURVIVAL_ERROR:^7 ------ no bot spawner DEFINED! ------");
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

	//Precache Support Shop Icon + Model if defined
	if(isDefined(level.shop_info["support"].model))
	{
		precacheModel(level.shop_info["support"].model);
	}
	if(isDefined(level.shop_info["support"].headIcon))
	{
		precacheShader(level.shop_info["support"].headIcon);
	}


	//Start Mod Systems
	level thread pix\server\_server::init();
	level thread pix\shop\_shop::init_shop();
	level thread pix\player\_player::spawn_players();
}