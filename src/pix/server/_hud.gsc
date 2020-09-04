#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

createServerHud()
{
    level.Hud = [];
    
    //Create the Wave Counter Hud
    level.Hud["Wave"] = createServerText("objective",1.5,"TOPLEFT","TOPLEFT",-55,-10+level.survival_hud_main_y,(1,1,1),0,(1,0,0),0);
    level.Hud["Wave"].hideWhenInMenu = true;
    level.Hud["Wave"].label = "Wave: ";
    level.Hud["Wave"] setValue(level.Wave);

    //Create the Enemies Left Counter Hud
    level.Hud["Enemies_Left"] = createServerText("objective",1.5,"TOPLEFT","TOPLEFT",-55,8+level.survival_hud_main_y,(1,1,1),0,(1,0,0),0);
    level.Hud["Enemies_Left"].hideWhenInMenu = true;
    level.Hud["Enemies_Left"].label = "Enemies Left: ";
    level.Hud["Enemies_Left"] setValue(0);
}

//Update Wave Counter Hud Value
updateWaveCounter(value)
{
    if(!isDefined(value))
    {
        value = level.Wave;
    }
    level.Hud["Wave"] elemFadeOverTime(.7,0);
    wait .8;
    level.Hud["Wave"] setValue(value);
    level.Hud["Wave"] elemFadeOverTime(.7,1);
}

//Update Enemies Left Counter Hud
updateEnemiesLeftCounter(value)
{
    if((value<=10) && (value>0))
    {
        level.Hud["Enemies_Left"] setValue(value);
        if(level.Hud["Enemies_Left"].alpha==0)
        {
            level.Hud["Enemies_Left"] elemFadeOverTime(.4,1);
            wait .4;
        }
    }
    else
    {
        if(level.Hud["Enemies_Left"].alpha>0)
        {
            level.Hud["Enemies_Left"] elemFadeOverTime(.7,0);
        }
    }
}

//Monitor Intermission Player Skip
intermission_players_skip()
{
    level endon("intermission_done");
    if(isDefined(level.Hud["intermission_skip_info"]))
    {
        level.Hud["intermission_skip_info"] destroy();
    }
    level.Hud["intermission_skip_info"] = createServerText("objective",1.3,"CENTER","BOTTOM",0,-10,(1,1,1),0,(0,1,0),0,"Press ^3[{+frag}]^7 + ^3[{+melee}]^7 to Skip!(0/"+getPlayers().size+")");
    level.Hud["intermission_skip_info"].hideWhenInMenu = true;
    level.intermissionSkipped_count = 0;
    foreach(player in getPlayers())
    {
        player.hasIntermissionSkipped = false;
    }
    level.Hud["intermission_skip_info"] elemFadeOverTime(.4,1);
    for(;;)
    {
        foreach(player in getPlayers())
        {
            if(player FragButtonPressed() && player MeleeButtonPressed())
            {
                if(!player.hasIntermissionSkipped)
                {
                    level.intermissionSkipped_count ++;
                    player.hasIntermissionSkipped = true;
                }
                wait .4;
            }
        }
        level.Hud["intermission_skip_info"] setText("Press ^3[{+frag}]^7 + ^3[{+melee}]^7 to Skip!("+level.intermissionSkipped_count+"/"+getPlayers().size+")");
        wait 0.05;
    }
}

//Do the actual intermission countdown
doIntermission()
{
    level.doing_intermission = true;
    level.Hud["intermission"] = createServerText("objective",1.3,"CENTER","BOTTOM",0,-30,0,(1,1,1),0,(0.3,0.6,0.3),1);
    level.Hud["intermission"].label = "Next Wave in: ";
    level.Hud["intermission"] setValue(level.IntermissionTime);
    level.Hud["intermission"] elemFadeOverTime(.4,1);
    wait .4;
    for(i=level.IntermissionTime;i>-1;i--)
    {
        if(everyPlayerHasSkippedIntermission())
        {
            continue;
        }
        level.Hud["intermission"] setValue(i);
        foreach(player in level.players)
        {
            player playLocalSound("match_countdown_tick");
        }
        wait 1;
    }
    level notify("intermission_done");
    level.Hud["intermission_skip_info"] elemFadeOverTime(.4,0);
    level.Hud["intermission"] elemFadeOverTime(.4,0);
    wait .4;
    level.Hud["intermission"] destroy();
    level.Hud["intermission_skip_info"] destroy();
    level.doing_intermission = false;
}

//Check if all players have skipped the intermission
everyPlayerHasSkippedIntermission()
{
    list = [];
    foreach(player in level.players)
    {
        if(player.hasIntermissionSkipped)
        {
            list[list.size] = player;
        }
    }
    if(list.size==level.players.size)
    {
        return true;
    }
    return false;
}