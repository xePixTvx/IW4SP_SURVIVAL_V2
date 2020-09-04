#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

//add spawner to pix_spawner array
addSpawner(id,type,origin)
{
	if(!pix\bot\_bot::isValidBotType(type))
	{
		iprintln("^1ERROR: UNKNOWN BOT TYPE!");
		return;
	}
	if(!isDefined(level.pix_spawner))
	{
		level.pix_spawner = [];
	}
	i = level.pix_spawner.size;
	level.pix_spawner[i] = spawnStruct();
	level.pix_spawner[i].id = id;
	level.pix_spawner[i].type = type;
	changeSpawnerOrigin(id,origin);
}

//change spawner position
changeSpawnerOrigin(id,origin)
{
	spawner = GetSpawnerArray();
	spawner[id].origin = origin;
}

//get random spawner by type(from pix_spawner array)
getRandomSpawner(type)
{
	if(!pix\bot\_bot::isValidBotType(type))
	{
		iprintln("^1ERROR: UNKNOWN BOT TYPE!");
		return;
	}
	list = [];
	for(i=0;i<level.pix_spawner.size;i++)
	{
		if(level.pix_spawner[i].type==type)
		{
			list[list.size] = level.pix_spawner[i].id;
		}
	}
	return list[randomInt(list.size)];
}