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
    level.survival_map_leaving_triggers[i] thread trigger_touch_test();
}


trigger_touch_test()
{
    for(;;)
    {
        self waittill("trigger");
        iprintlnBold("^1Touching");
    }
}