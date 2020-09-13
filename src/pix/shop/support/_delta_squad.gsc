#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

addDeltaSquad(spawnpoint,id1,id2,id3,id4)
{
    level.DeltaSquad = spawnStruct();
    level.DeltaSquad.spawnpoint = spawnpoint;
    level.DeltaSquad.spawner_id = [];
    if(isDefined(id1))
    {
        level.DeltaSquad.spawner_id[0] = id1;
        pix\bot\_bot_spawner::changeSpawnerOrigin(id1,spawnpoint);
    }
    if(isDefined(id2))
    {
        level.DeltaSquad.spawner_id[1] = id2;
        pix\bot\_bot_spawner::changeSpawnerOrigin(id2,spawnpoint);
    }
    if(isDefined(id3))
    {
        level.DeltaSquad.spawner_id[2] = id3;
        pix\bot\_bot_spawner::changeSpawnerOrigin(id3,spawnpoint);
    }
    if(isDefined(id4))
    {
        level.DeltaSquad.spawner_id[3] = id4;
        pix\bot\_bot_spawner::changeSpawnerOrigin(id4,spawnpoint);
    }
}


buy_deltaSquad(price)
{
    if(level.DeltaSquad_Active)
    {
        iprintlnBold("^1Delta Squad already active!");
        return;
    }
    if(!self pix\player\_money::hasPlayerEnoughMoney(price))
    {
        iprintlnBold("^1Not Enough Money!");
        return;
    }
	self pix\player\_money::takePlayerMoney(price);
    wait .5;
    self notify("shopMenu_close");
    self thread doDeltaSquad();
}

doDeltaSquad()
{
    level.DeltaSquad_Active = true;
    level.DeltaSquad_bots_alive = 0;
    level thread monitorDeltaSquadBotsAlive();
    for(i=0;i<4;i++)
	{
        if(isDefined(level.DeltaSquad.spawner_id[i]))
        {
		    level thread spawnDeltaSquadBot(level.DeltaSquad.spawner_id[i],self);
        }
		wait .2;
	}
}

monitorDeltaSquadBotsAlive()
{
	while(level.DeltaSquad_Active)
	{
		level waittill("deltasquad_bot_died");
		level.DeltaSquad_bots_alive --;
		if(level.DeltaSquad_bots_alive<=0)
		{
			level.DeltaSquad_Active = false;
		}
		wait 0.05;
	}
}

spawnDeltaSquadBot(id,owner)
{
	spawners = GetSpawnerArray();
	spawners[id].script_forcespawn = true;
    spawners[id].script_delayed_playerseek = undefined;
	spawners[id].script_playerseek = undefined;
	spawners[id].script_pacifist = undefined;
	spawners[id].script_ignoreme = true;
	spawners[id].dontdropweapon = undefined;
	spawners[id].script_stealth = undefined;
	spawners[id].count = 9999;
	
	bot = spawners[id] stalingradspawn();
	bot.team = "allies";
	bot.health = 6000;//6000;
	bot.deltasquad_owner = owner;
	level.DeltaSquad_bots_alive ++;
    wait 0.05;
    bot thread monitorDeltaSquadBotDeath();
    bot thread monitorDeltaSquadBotOwnerDistance();
}

monitorDeltaSquadBotDeath()
{
	self endon("dsg_death");
	for(;;)
	{
		self waittill("death");
		level notify("deltasquad_bot_died");
		self notify("dsg_death");
		wait 0.05;
	}
}

monitorDeltaSquadBotOwnerDistance()
{
    self.goalradius = 500;
    self enable_danger_react(10);
    self endon("dsg_death");
    for(;;)
    {
        if(distanceSquared(self.origin,self.deltasquad_owner.origin) > (self.goalradius*self.goalradius))
        {
            self setGoalEntity(self.deltasquad_owner);
			wait 2;
        }
        wait 2;
    }
}
