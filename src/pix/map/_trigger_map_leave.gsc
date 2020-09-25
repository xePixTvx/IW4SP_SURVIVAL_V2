#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

//Origin: (-4506.39, -5559.04, 2310.13) Angles: (0, -90.1776, 0)

addMapLeavingTrigger(origin,width,height,cursorHint,string)
{
    trigger = spawn("trigger_radius",origin,1,width,height);
    trigger thread trigger_touch_test();
    thread showToPlayers(origin);
    return trigger;
}


trigger_touch_test()
{
    for(;;)
    {
        self waittill("trigger");
        iprintlnBold("^1Touching");
    }
}




showToPlayers(point)
{
    for(;;)
    {
        print3D(point+(0,0,50),"Trigger",(1,0,0),1,1.5,1);
        wait 0.05;
    }
}