#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

init_wave()
{
    //If max bots is not defined set it to 30
    if(!isDefined(level.MaxBots))
    {
        level.MaxBots = 30;
    }

    //Valid Wave Schemes
    level.wave_schemes = make_array("default","default_dogs","default_juggers","default_dogs_juggers");

    //Default Settings
    setupWaveBotSettings("default",120,50,5,80);
    setupWaveBotSettings("dog",140,50,5,100);
    setupWaveBotSettings("jugger",3600,150,5,100);

    //Bot Amount Default
    level.wave_bot_amount = [];
    level.wave_bot_amount["default"] = 13;//Wave 0 to Wave 1 adds 2 so first wave has 15 default bots
    level.wave_bot_amount["dog"] = 0;//should be introduced with a dog only wave
    level.wave_bot_amount["jugger"] = 0;//should be introduced with a jugger only wave

    
    level thread start_first_wave();
    level thread monitor_wave();
    level thread monitor_enemy_count();
}

//Start first wave when the host is spawned
start_first_wave()
{
    level waittill("host_spawn_complete");
    level notify("next_wave");
}

//Start a new wave after "next_wave" is notified
monitor_wave()
{
    for(;;)
    {
        level waittill("next_wave");
        if(level.DEV_ALLOW_START||!isDefined(level.DEV_ALLOW_START))
        {
            
            //If Wave counter is not visible make it visible
            if(level.Hud["Wave"].alpha==0)
            {
                level.Hud["Wave"] elemFadeOverTime(.4,1);
            }

            level thread pix\server\_hud::intermission_players_skip();
            level thread pix\server\_hud::doIntermission();
            level waittill("intermission_done");
            level.Wave ++;
            level thread pix\server\_hud::updateWaveCounter();
            wait .4;
            level doWave();
        }
    }
}

//Update multiple things when "update_enemy_count" is notified
monitor_enemy_count()
{
    for(;;)
    {
        level waittill("update_enemy_count");

        //Update Enemies Left Hud
        enemies_left_value = level.pix_bot_count;
        level thread pix\server\_hud::updateEnemiesLeftCounter(enemies_left_value);

        //Start next wave if no enemies are left
        if(level.pix_bot_count<=0)
        {
            level notify("next_wave");
            level.pix_bots = [];
            level.pix_bot_count = 0;
            wait 0.05;
        }

        //Pause Bot Spawning when max is reached
        if(level.pix_bot_count>=level.MaxBots)
        {
            level.canSpawnBots = false;
        }
    }
}

//Change Bot Settings
setupWaveBotSettings(bot_type,health,kill_reward,hit_reward,headshot_reward)
{
    if(!pix\bot\_bot::isValidBotType(bot_type))
    {
        return;
    }
    if(!isDefined(level.wave_bot_settings))
    {
        level.wave_bot_settings = [];
    }
    level.wave_bot_settings[bot_type] = spawnStruct();
    level.wave_bot_settings[bot_type].health = health;
    level.wave_bot_settings[bot_type].kill_reward = kill_reward;
    level.wave_bot_settings[bot_type].hit_reward = hit_reward;
    level.wave_bot_settings[bot_type].headshot_reward = headshot_reward;
}



//Setup Current Wave
doWave()
{
    if(!pix\server\_scheme::isValidWaveScheme(level.wave_scheme))
    {
        iprintln("^1ERROR: UNKNOWN WAVE SCHEME!");
        return;
    }

    if(level.wave_scheme=="default")
    {
        level pix\server\_scheme::setup_default_bots();
    }
    else if(level.wave_scheme=="default_dogs")
    {
        level pix\server\_scheme::setup_default_bots();
        level pix\server\_scheme::setup_dog_bots();
    }
    else if(level.wave_scheme=="default_juggers")
    {
        level pix\server\_scheme::setup_default_bots();
        level pix\server\_scheme::setup_jugger_bots();
    }
    else if(level.wave_scheme=="default_dogs_juggers")
    {
        level pix\server\_scheme::setup_default_bots();
        level pix\server\_scheme::setup_dog_bots();
        level pix\server\_scheme::setup_jugger_bots();
    }


    level thread spawnBots();//default delay should be good
}

//Spawn Bots For Wave
spawnBots(spawn_delay)
{
    if(!isDefined(spawn_delay))
    {
        spawn_delay = .4;//.2 ---- .4 just for testing right now
    }
    
    level.canSpawnBots = true;

    allowSpawnAgain = randomIntRange(int(level.MaxBots/2),int(level.MaxBots-5));//maybe needs some work
    
    default_bots  = level.wave_bot_amount["default"];
    dog_bots = level.wave_bot_amount["dog"];
    jugger_bots  = level.wave_bot_amount["jugger"];
    
    total = default_bots + dog_bots + jugger_bots;
    
    level endon("end_Wave_Bot_Spawning");
    while(total>0)
    {
        if(level.canSpawnBots)
        {
            if(default_bots>0)
            {
                pix\bot\_bot::spawnBot(pix\bot\_bot_spawner::getRandomSpawner("default"),"default",level.wave_bot_settings["default"].health,level.wave_bot_settings["default"].kill_reward,level.wave_bot_settings["default"].hit_reward,level.wave_bot_settings["default"].headshot_reward);
                default_bots --;
                total --;
            }
            if(dog_bots>0)
            {
                pix\bot\_bot::spawnBot(pix\bot\_bot_spawner::getRandomSpawner("dog"),"dog",level.wave_bot_settings["dog"].health,level.wave_bot_settings["dog"].kill_reward,level.wave_bot_settings["dog"].hit_reward,level.wave_bot_settings["dog"].headshot_reward);
                dog_bots --;
                total --;
            }
            if(jugger_bots>0)
            {
                pix\bot\_bot::spawnBot(pix\bot\_bot_spawner::getRandomSpawner("jugger"),"jugger",level.wave_bot_settings["jugger"].health,level.wave_bot_settings["jugger"].kill_reward,level.wave_bot_settings["jugger"].hit_reward,level.wave_bot_settings["jugger"].headshot_reward);
                jugger_bots --;
                total --;
            }
        }
        else
        {
            if(level.pix_bot_count<=allowSpawnAgain)
            {
                level.canSpawnBots = true;
            }
        }
        //iprintln("^1TOTAL: ^2"+total);
        wait spawn_delay;
    }
}