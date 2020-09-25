#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

//set developer and developer_script dvars to 1 to use dev options

_init_dev_tool()
{
	level.DEV_ALLOW_START = false;
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
	dev_info_texts[10] = "^3M^7 - Test Function";
	dev_info_texts[11] = "^3L^7 - Show Survival Spawnpoints";

	self.DEV_HUD["Info"] = [];
	for(i=0;i<dev_info_texts.size;i++)
	{
		self.DEV_HUD["Info"][i] = createText("console",1.0,"TOPLEFT","TOPLEFT",-55,120+(12*i),(1,1,1),1,(0.3,0.6,0.3),0,dev_info_texts[i]);
	}
	
	level.SuperSpeed = false;
	self.dev_god = false;
	test_bot_spawner_cycle = 0;
	level.isPrintingInfoDump = false;
	self.dev_showSpawnpoints = false;

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
			iprintln("Printed to Console!");
			printToConsole("Origin: " + self.origin);
			printToConsole("Angles: " + self.angles);
			wait .4;
		}
		if(self buttonPressed("o"))
		{
			bot_spawners = GetSpawnerArray();
			self thread dev_dumpInfoToConsole(bot_spawners,"Bot Spawner");
			wait .4;
		}
		if(self buttonPressed("p"))
		{
			vehicle_spawners = GetVehicleSpawnerArray();
			self thread dev_dumpInfoToConsole(vehicle_spawners,"Vehicle Spawner");
			wait .4;
		}
		if(self buttonPressed("h"))
		{
			ent_array = GetEntArray();
			self thread dev_dumpInfoToConsole(ent_array,"Entity");
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
			iprintln("^1UNFINISHED!");
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
		if(self buttonPressed("m"))
		{
			self _dev_test_function();
			wait .4;
		}
		if(self buttonPressed("l"))
		{
			if(!self.dev_showSpawnpoints)
			{
				self.dev_showSpawnpoints = true;
				self thread dev_showSpawnpoints();
				iprintln("Show Survival Spawnpoints - ^2ON");
			}
			else
			{
				self.dev_showSpawnpoints = false;
				self notify("end_show_spawnpoints");
				iprintln("Show Survival Spawnpoints - ^1OFF");
			}
			wait .4;
		}
		wait 0.05;
	}
}

//you need to do it a few times to dump all
dev_dumpInfoToConsole(arrayToDump,printingName)
{
	if(level.isPrintingInfoDump)
	{
		iprintlnBold("^1Already Dumping Info!");
		return;
	}
	if(arrayToDump.size<=0)
	{
		iprintln("^1No " + printingName + " Found!");
		return;
	}
	level.isPrintingInfoDump = true;
	array = arrayToDump;
	iprintln("^1Printing " + printingName + ".....");
	printToConsole("");
	printToConsole("---------------------------------------------------------------");
	printToConsole("--- IW4SP_SURVIVAL " + printingName + " Info Dump ---");
	printToConsole("--- Size: " + array.size + " ---");
	printToConsole("---------------------------------------------------------------");
	wait .5;
	for(i=0;i<array.size;i++)
	{
		iprintln("Printing " + printingName + ": ^1"+i);
		printToConsole("");
		printToConsole("----------------------------------");
		printToConsole("Index Number(id): " + i);
		printToConsole("Classname: " + array[i].classname);
		printToConsole("Targetname: " + array[i].targetname);
		printToConsole("----------------------------------");
		wait .2;
	}
	iprintln("^1Printing Finished!");
	level.isPrintingInfoDump = false;
}


dev_showSpawnpoints()
{
	self endon("end_show_spawnpoints");
	for(;;)
	{
		/#
		if(isDefined(level.bot_spawnPoints))
		{
			foreach(index,point in level.bot_spawnPoints)
			{
				print3D(point+(0,0,50),"Bot Spawnpoint: " + index,(1,0,0),1,1.5,1);
				line(self.origin+(0,0,50),point+(0,0,50),(1,0,0));
			}
		}
		if(isDefined(level.player1_spawnPoint))
		{
			print3D(level.player1_spawnPoint+(0,0,50),"Player1 Spawnpoint",(0,1,0),1,1.5,1);
			line(self.origin+(0,0,50),level.player1_spawnPoint+(0,0,50),(0,1,0));
		}
		if(isDefined(level.player2_spawnPoint))
		{
			print3D(level.player2_spawnPoint+(0,0,50),"Player2 Spawnpoint",(0,1,0),1,1.5,1);
			line(self.origin+(0,0,50),level.player2_spawnPoint+(0,0,50),(0,1,0));
		}
		if(isDefined(level.DeltaSquad.spawnpoint))
		{
			print3D(level.DeltaSquad.spawnpoint+(0,0,50),"Delta Squad Spawnpoint",(0,0,1),1,1.5,1);
			line(self.origin+(0,0,50),level.DeltaSquad.spawnpoint+(0,0,50),(0,0,1));
		}
		#/
		wait 0.05;
	}
}


_dev_test_function()
{
	iprintln("_dev_test_function() ^1Executed!");
}
