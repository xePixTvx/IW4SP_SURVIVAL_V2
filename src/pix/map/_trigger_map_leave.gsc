#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

addMapLeavingTrigger(origin,radius)
{
    if(!isDefined(level.survival_map_leaving_triggers))
    {
        level.survival_map_leaving_triggers = [];
    }
    i = level.survival_map_leaving_triggers.size;
    level.survival_map_leaving_triggers[i] = spawn("trigger_radius",origin,1,radius,200);
    level.survival_map_leaving_triggers[i].type = "trigger_map_leave";
    level.survival_map_leaving_triggers[i].centerPos = origin;
    level.survival_map_leaving_triggers[i].radius = radius;
    level.survival_map_leaving_triggers[i] thread updateMapLeavingTrigger();
}


updateMapLeavingTrigger()
{
    for(;;)
    {
        self waittill("trigger",player);
        self thread updateMapLeavingPlayer(player);
    }
}


updateMapLeavingPlayer(player)
{
    if(!isDefined(player.isInsideMapLeaveTrigger))
    {
        player.isInsideMapLeaveTrigger = false;
    }
    if(player.isInsideMapLeaveTrigger)
    {
        return;
    }
    player.isInsideMapLeaveTrigger = true;
    while(player isTouching(self))
    {
        iprintln("^1UPDATE");
        wait 2;
    }
    player.isInsideMapLeaveTrigger = false;
}