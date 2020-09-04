#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

//use level.player thread pix\_dev::_init_dev_tool(); --- on map main() function --- before mod setup

_init_dev_tool()
{
	level.DEV_ALLOW_START = true;
	level.DEV_BOTS_PACIFIST = false;
	
	
	self.DEV_HUD = [];
	
	dev_info_texts = [];
	dev_info_texts[0] = "^3Z^7 - Godmode";
	dev_info_texts[1] = "^3Y^7 - Give ^2+1000$";
	dev_info_texts[2] = "^3U^7 - Kill All Enemies(skip wave)";
	dev_info_texts[3] = "^3I^7 - Print Player Location + Angles";
	dev_info_texts[4] = "^3O^7 - Print Bot Spawners";
	dev_info_texts[5] = "^3P^7 - Print Vehicle Spawners";
	dev_info_texts[6] = "^3H^7 - Print Entities";
	dev_info_texts[7] = "^3J^7 - Test Survival Spawners";
	dev_info_texts[8] = "^3K^7 - Test Vehicle Spawner";
	dev_info_texts[9] = "^3N^7 - Super Speed";
	dev_info_texts[10] = "^3L^7 - Clear Print String";

	self.DEV_HUD["print_1"] = createText("default",1.5,"CENTER","CENTER",0,0,(1,1,1),1,(0,0,0),0);
	self.DEV_HUD["print_2"] = createText("default",1.5,"CENTER","CENTER",0,30,(1,1,1),1,(0,0,0),0);
	self.DEV_HUD["print_3"] = createText("default",1.5,"CENTER","CENTER",0,60,(1,1,1),1,(0,0,0),0);
	self.DEV_HUD["print_4"] = createText("default",1.5,"CENTER","CENTER",0,90,(1,1,1),1,(0,0,0),0);
	self.DEV_HUD["Info"] = [];
	for(i=0;i<dev_info_texts.size;i++)
	{
		self.DEV_HUD["Info"][i] = createText("console",1.0,"TOPLEFT","TOPLEFT",-55,120+(12*i),(1,1,1),1,(0.3,0.6,0.3),0,dev_info_texts[i]);
	}
	
	level.SuperSpeed = false;
	self.dev_god = false;
	bot_spawners = GetSpawnerArray();
	bot_spawner_cycle = 0;
	vehicle_spawners = GetVehicleSpawnerArray();
	vehicle_spawner_cycle = 0;
	ents = GetEntArray();
	ent_cycle = 0;
	test_bot_spawner_cycle = 0;
	
	
	self endon("end_dev_tool");
	for(;;)
	{
		if(self.dev_god)
		{
			self enableInvulnerability();
		}
		if(self buttonPressed("z"))
		{
			if(!self.dev_god)
			{
				self.dev_god = true;
				iprintln("Godmode - ^2ON");
			}
			else
			{
				self.dev_god = false;
				wait 0.05;
				self disableInvulnerability();
				iprintln("Godmode - ^1OFF");
			}
			wait .4;
		}
		if(self buttonPressed("y"))
		{
			self pix\player\_money::givePlayerMoney(1000);
			wait .4;
		}
		if(self buttonPressed("u"))
		{
			level thread pix\bot\_bot::kill_all_bots();
			iprintln("^1All Bots Killed!");
			wait .4;
		}
		if(self buttonPressed("i"))
		{
			self _setPrintString("Origin: " + self.origin,"Angles: " + self.angles);
			wait .4;
		}
		if(self buttonPressed("o"))
		{
			self _setPrintString("Bot Spawners: " + bot_spawners.size,"id: " + bot_spawner_cycle + " ----- classname: " + bot_spawners[bot_spawner_cycle].classname,"id: " + bot_spawner_cycle + " ----- targetname: " + bot_spawners[bot_spawner_cycle].targetname);
			bot_spawner_cycle ++;
			wait .4;
		}
		if(self buttonPressed("p"))
		{
			self _setPrintString("Vehicle Spawners: " + vehicle_spawners.size,"id: " + vehicle_spawner_cycle + " ----- classname: " + vehicle_spawners[vehicle_spawner_cycle].classname,"id: " + vehicle_spawner_cycle + " ----- targetname: " + vehicle_spawners[vehicle_spawner_cycle].targetname);
			vehicle_spawner_cycle ++;
			wait .4;
		}
		if(self buttonPressed("h"))
		{
			self _setPrintString("Entities: " + ents.size,"id: " + ent_cycle + " ----- classname: " + ents[ent_cycle].classname,"id: " + vehicle_spawner_cycle + " ----- targetname: " + ents[ent_cycle].targetname,"id: " + vehicle_spawner_cycle + " ----- model: " + ents[ent_cycle].model);
			ent_cycle ++;
			wait .4;
		}
		if(self buttonPressed("j"))
		{
			iprintln("Spawner: " + test_bot_spawner_cycle + " ----- id: " + level.pix_spawner[test_bot_spawner_cycle].id);
			thread pix\bot\_bot::spawnBot(level.pix_spawner[test_bot_spawner_cycle].id,level.pix_spawner[test_bot_spawner_cycle].type);
			test_bot_spawner_cycle ++;
			wait .4;
		}
		if(self buttonPressed("k"))
		{
			//iprintln("^1UNFINISHED!");
			//heli_strike_heli
			//thread pix\bot\_vehicle::_spawnEnemyHeli("harrier");//change targetname to the one you want to test or use kill_heli
			wait .4;
		}
		if(self buttonPressed("n"))
		{
			if(!level.SuperSpeed)
			{
				level.SuperSpeed = true;
				level.default_run_speed = 400;
				setSavedDvar("g_speed",level.default_run_speed);
				iprintln("Super Speed - ^2ON");
			}
			else
			{
				level.SuperSpeed = false;
				level.default_run_speed = 190;
				setSavedDvar("g_speed",level.default_run_speed);
				iprintln("Super Speed - ^1OFF");
			}
			wait .4;
		}
		if(self buttonPressed("l"))
		{
			self _setPrintString();
			wait .4;
		}
		wait 0.05;
	}
}
_setPrintString(a,b,c,d)
{
	if(!isDefined(a))
	{
		a = "";
	}
	if(!isDefined(b))
	{
		b = "";
	}
	if(!isDefined(c))
	{
		c = "";
	}
	if(!isDefined(d))
	{
		d = "";
	}
	self.DEV_HUD["print_1"] setText(a);
	self.DEV_HUD["print_2"] setText(b);
	self.DEV_HUD["print_3"] setText(c);
	self.DEV_HUD["print_4"] setText(d);
}