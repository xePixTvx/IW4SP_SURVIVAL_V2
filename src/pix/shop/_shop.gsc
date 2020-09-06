#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

init_shop()
{
    level.shop_types = make_array("weapon","support");

    level.shop_model = [];
    level waittill("host_spawn_complete");
    foreach(type in level.shop_types)
    {
        if(isDefined(level.shop_info[type]))
        {
            level.shop_model[type] = spawnShopModel(level.shop_info[type].pos,level.shop_info[type].angles,level.shop_info[type].model,level.shop_info[type].headIcon);
        }
    }
    wait 0.05;
	level thread shop_monitor();
}


shop_monitor()
{
	for(;;)
    {
        foreach(player in getPlayers())
        {
            foreach(type in level.shop_types)
            {
				if(isDefined(level.shop_model[type]) && isDefined(level.shop_info[type].mainFunction))
                {
                    if(distance(level.shop_model[type].origin,player.origin)<=100)
                    {
                        if(player thread [[level.shop_info[type].mainFunction]](level.shop_info[type].lowMsg,level.shop_info[type].unlock_wave))
                        {
                            wait .6;
                        }
                    }
                    if(!player isNearAnyShop())
                    {
                        player pix\player\_lowerMsg::clearLowerMsg();
                    }
                }
            }
        }
        wait 0.05;
    }
}

isNearAnyShop()
{
	for(i=0;i<level.shop_types.size;i++)
	{
		if(distance(level.shop_model[level.shop_types[i]].origin,self.origin)<=100)
		{
			return true;
		}
	}
	return false;
}






//Spawn Shop Model
spawnShopModel(pos,angles,model,icon)
{
	//dont just call it "model" cause it confuses the game xD
	shopmodel = spawn("script_model",pos);
    shopmodel.angles = angles;
	shopmodel setModel(model);
	shopmodel thread shop_SetEntHeadIcon((0,0,50),icon,true);
	shopmodel Solid();
	shopmodel CloneBrushModelToScriptmodel();
	return shopmodel;
}

//Shop Model Headicon stuff
shop_SetEntHeadIcon(offset, shader, keepPosition)
{
	if (isDefined(offset)) self.entityHeadIconOffset = offset;
	else self.entityHeadIconOffset = (0,0,0);
	headIcon = newHudElem();
	headIcon.archived = true;
	headIcon.x = self.origin[0]+self.entityHeadIconOffset[0];
	headIcon.y = self.origin[1]+self.entityHeadIconOffset[1];
	headIcon.z = self.origin[2]+self.entityHeadIconOffset[2];
	headIcon.alpha = 0.8;
	headIcon setShader(shader,10,10);
	headIcon setWaypoint(true,true);
	self.entityHeadIcon = headIcon;
	if(isdefined(keepPosition)&&keepPosition==true)
	{
		self thread shop_keepIconPositioned();
	}
}
shop_keepIconPositioned()
{
	self endon("kill_entity_headicon_thread");
	self endon("death");	
	pos = self.origin;
	while(1)
	{
		if(pos!=self.origin) 
		{
			self shop_updateHeadIconOrigin();
			pos = self.origin;
		}
		wait .05;
	}
}
shop_updateHeadIconOrigin()
{
	self.entityHeadIcon.x = self.origin[0]+self.entityHeadIconOffset[0];
	self.entityHeadIcon.y = self.origin[1]+self.entityHeadIconOffset[1];
	self.entityHeadIcon.z = self.origin[2]+self.entityHeadIconOffset[2];
}