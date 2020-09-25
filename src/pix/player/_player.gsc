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
	self.has_faster_movement = false;
	self.has_mortar_strike = false;

	self takeAllWeapons();
	self giveWeapon(level.startWeapon,0);
	self switchToWeapon(level.startWeapon);

	//Do intro
	if(level.players_intro=="default_zoom_in")
	{
		self thread pix\player\_intro::intro_flying_default();
	}

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
	self thread unlock_all_achiev();
}



unlock_all_achiev()
{
	self.isUnlockingAll = true;
	useBar = createClientProgressBar( self, 25 );
	progress = 0;
	missionString = self GetLocalPlayerProfileData( "missionHighestDifficulty" );
	newString = "";
	Achievement = strTok("BACK_IN_THE_SADDLE|DANGER_CLOSE|COLD_SHOULDER|TAGEM_AND_BAGEM|ROYAL_WITH_CHEESE|SOAP_ON_A_ROPE|DESPERATE_TIMES|HOUSTON_WE_HAVE_A_PROBLEM|THE_PAWN|OUT_OF_THE_FRYING_PAN|FOR_THE_RECORD|THE_PRICE_OF_WAR|FIRST_DAY_OF_SCHOOL|BLACK_DIAMOND|TURISTAS|RED_DAWN|PRISONER_627|ENDS_JUSTIFY_THE_MEANS|HOME_COMING|QUEEN_TAKES_ROOK|OFF_THE_GRID|PIT_BOSS|GHOST|HOUSTON_WE_HAVE_A_PROBLEM|COLONEL_SANDERSON|GOLD_STAR|HOTEL_BRAVO|CHARLIE_ON_OUR_SIX|IT_GOES_TO_ELEVEN|OPERATIONAL_ASSET|BLACKJACK|HONOR_ROLL|OPERATIVE|SPECIALIST|PROFESSIONAL|STAR_69|THREESOME|DOWNED_BUT_NOT_OUT|NO_REST_FOR_THE_WARY|IM_THE_JUGGERNAUT|ONE_MAN_ARMY|TEN_PLUS_FOOT_MOBILES|UNNECESSARY_ROUGHNESS|KNOCK_KNOCK|LOOK_MA_TWO_HANDS|SOME_LIKE_IT_HOT|TWO_BIRDS_WITH_ONE_STONE|THE_ROAD_LESS_TRAVELED|LEAVE_NO_STONE_UNTURNED|DRIVE_BY|THE_HARDER_THEY_FALL", "|" );
	for ( index = 0;index < missionString.size;index++ )
	{
		if( index < 20 ) newString += "44";
		else newString += 0;
	}
	if(self GetLocalPlayerProfileData( "highestMission" ) != 25) 
		self SetLocalPlayerProfileData( "highestMission", 25 );
	if(self GetLocalPlayerProfileData( "cheatPoints" ) != 45) 
		self SetLocalPlayerProfileData( "cheatPoints", 45 );
	if(self GetLocalPlayerProfileData( "missionHighestDifficulty" ) != newString) 
		self SetLocalPlayerProfileData( "missionHighestDifficulty", newString );
	if(self GetLocalPlayerProfileData( "PercentCompleteSO" ) != 69) 
		self SetLocalPlayerProfileData( "PercentCompleteSO", 69 );
	if(self GetLocalPlayerProfileData( "percentCompleteSP" ) != 10000) 
		self SetLocalPlayerProfileData( "percentCompleteSP", 10000 );
	if(self GetLocalPlayerProfileData( "percentCompleteMP" ) != 1100) 
		self SetLocalPlayerProfileData( "percentCompleteMP", 1100 );
	if(self GetLocalPlayerProfileData( "missionsohighestdifficulty" ) != "44444444444444444444444444444444444444444444444444")
		self SetLocalPlayerProfileData( "missionsohighestdifficulty", "44444444444444444444444444444444444444444444444444" );
	for( s = 0; s <= Achievement.size; s++ )
	{
		//self thread player_giveachievement_wrapper( Achievement[s] );
		progress++;
		percent = ceil( (progress/50) * 100 );
		useBar updateBar( percent / 100 );
		wait 0.5;
	}
	useBar destroyElem();
	UpdateGamerProfile();
	self.isUnlockingAll = false;
	self.unlockedAll = true;
}