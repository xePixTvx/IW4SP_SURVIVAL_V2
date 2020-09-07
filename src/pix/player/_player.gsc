#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\player\_money;
#include pix\player\_armor;

//Add Spawnpoint,SpawnAngle and Startweapon for players
addPlayers(spawnpoint1,spawnangles1,spawnpoint2,spawnangles2,startweapon)
{
	level.player1_spawnPoint = spawnpoint1;
	level.player1_spawnAngle = spawnangles1;
	level.player2_spawnPoint = spawnpoint2;
	level.player2_spawnAngle = spawnangles2;
	level.startWeapon = startweapon;
}

//Teleport Players to Spawnpoint,set spawnangle and start the actual spawning
spawn_players()
{
	getPlayer1() setOrigin(level.player1_spawnPoint);
	getPlayer1() setPlayerAngles(level.player1_spawnAngle);
	getPlayer1() thread init_player();
	if(is_coop())
	{
		getPlayer2() setOrigin(level.player2_spawnPoint);
		getPlayer2() setPlayerAngles(level.player2_spawnAngle);
		getPlayer2() thread init_player();
	}
}

//Do actual spawn --- set all to default,remove/give weapons,do intro..........
init_player()
{
	self.Hud = [];
	self setPlayerMoney(0);
	self setPlayerArmor(50);

	self.maxHealth = 100;
	self.health = 100;
	self.max_weapons = 2;
	self takeAllWeapons();
	self giveWeapon(level.startWeapon,0);
	self switchToWeapon(level.startWeapon);

	//Do intro
	self thread pix\player\_intro::intro_flying_default();

	self waittill("intro_done");
	self pix\player\_lowerMsg::initPlayerLowerMsg();
	self pix\shop\menu\_menu::setupMenuForPlayer();
	self pix\player\_hud::createHud();
	wait .4;
	self thread pix\player\_hud::fadeHud(.7,1);
	self thread monitor_player_armor();
	wait 2;
	if(self isHostPlayer())
	{
		level notify("host_spawn_complete");
	}
}