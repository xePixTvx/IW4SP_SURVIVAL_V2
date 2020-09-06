#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

init_bot()
{
    level.pix_bots = [];
    level.pix_bot_count = 0;

    //DEV STUFF
	if(!level.DEV_BOTS_PACIFIST||!isDefined(level.DEV_BOTS_PACIFIST))
	{
		level.bot_pacifistMode = undefined;
	}
	else
	{
		level.bot_pacifistMode = true;
	}
	//DEV STUFF END
	
	level.bot_dontdropweapons = undefined;//gets enabled when weaponshop is unlocked

	level.botTypes = make_array("default","dog","jugger");

	//default bot --- start health = 120
	//dog bot --- start health = 140
	//jugger bot --- start health = 3600
}


//Spawn a bot
spawnBot(spawner_id,type,health,kill_reward,hit_reward,headshot_reward)//add accuracy?????
{
	if(!isValidBotType(type))
	{
		iprintln("^1ERROR: UNKNOWN BOT TYPE!");
		return;
	}

	if(!isDefined(health))
	{
		health = 120;
	}
	if(!isDefined(kill_reward))
	{
		kill_reward = 50;
	}
	if(!isDefined(hit_reward))
	{
		hit_reward = 5;
	}
	if(!isDefined())
	{
		headshot_reward = 20;
	}

	spawners = GetSpawnerArray();
	spawners[spawner_id].script_forcespawn = true;//force spawner to stalingradspawn ai
	spawners[spawner_id].script_playerseek = true;//ai runs to player
	spawners[spawner_id].script_pacifist = level.bot_pacifistMode;//ai only attacks after you hurt it
	spawners[spawner_id].script_ignoreme = undefined;//ai ignores player
	spawners[spawner_id].dontdropweapon = level.bot_dontdropweapons;//self explaining
	spawners[spawner_id].script_moveoverride = undefined;
	spawners[spawner_id].script_patroller = undefined;
	spawners[spawner_id].script_stealth = undefined;
	spawners[spawner_id].script_startrunning = true;
	spawners[spawner_id].count = 9999;
	
	bot = spawners[spawner_id] stalingradspawn();
	bot.team = "axis";
	bot.bot_type = type;
	bot.maxhealth = health;
	bot.health = bot.maxhealth;
	bot.kill_reward = kill_reward;
	bot.hit_reward = hit_reward;
	bot.headshot_reward = headshot_reward;
	if(bot.bot_type=="default")
	{
		if(toLower(getDvar("mapname"))=="airport" && spawner_id==3)
		{
			bot.name = "Asshole";
			bot.battleChatter = false;//so they shut up
		}
		if(toLower(getDvar("mapname"))=="so_takeover_estate" && spawner_id==145)
		{
			bot.name = "Idiot";
			bot.battleChatter = false;//so they shut up
		}
	}
	bot thread monitor_bot_death();
	bot thread monitor_bot_damage();
}

//Monitor Bot Death
monitor_bot_death()
{
	self endon("bot_death");
	addToBotList(self);
	for(;;)
	{
		self waittill("death",attacker);
		if(self.damageLocation == "head")
		{
			attacker pix\player\_money::givePlayerMoney(self.kill_reward,self.headshot_reward);
		}
		else
		{
			attacker pix\player\_money::givePlayerMoney(self.kill_reward);
		}
		removeFromBotList(self);
		self notify("bot_death");
		wait 0.05;
	}
}

//Monitor Bot Damage
monitor_bot_damage()
{
	self endon("bot_death");
	for(;;)
	{
		self waittill("damage",damage,attacker,direction_vec,point,type,modelName,tagName);
		attacker pix\player\_money::givePlayerMoney(self.hit_reward);
		wait 0.05;
	}
}




//Add a bot to pix_bots array
addToBotList(bot)
{
	if(!isValidBotType(bot.bot_type))
	{
		iprintln("^1ERROR: UNKNOWN BOT TYPE!");
		return;
	}
    i = level.pix_bots.size;
    level.pix_bots[i] = bot;
    level.pix_bot_count ++;
    level notify("update_enemy_count");
}

//Remove a bot from pix_bots array
removeFromBotList(bot)
{
	if(!isValidBotType(bot.bot_type))
	{
		iprintln("^1ERROR: UNKNOWN BOT TYPE!");
		return;
	}
    level.pix_bot_count --;
    level notify("update_enemy_count");
}

//Kill all Bots
kill_all_bots()
{
	for(i=0;i<level.pix_bots.size;i++)
	{
		level.pix_bots[i] doDamage((level.pix_bots[i].maxhealth*99999),(0,0,0));
	}
}

//Check for valid bot type
isValidBotType(type)
{
    for(i=0;i<level.botTypes.size;i++)
    {
        if(level.botTypes[i]==type)
        {
            return true;
        }
    }
    return false;
}