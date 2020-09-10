#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

setup_default_bots()
{
    if(level.Wave<=10)
	{
		level.wave_bot_amount["default"] += 2;
		level.wave_bot_amount["dog"] = 0;
    	level.wave_bot_amount["jugger"] = 0;

		pix\server\_wave::setupWaveBotSettings("default",120,50,5,80);
	}
	else if(level.Wave>10 && level.Wave<16)
	{
		level.wave_bot_amount["default"] += 2;
		level.wave_bot_amount["dog"] = 0;
    	level.wave_bot_amount["jugger"] = 0;

		pix\server\_wave::setupWaveBotSettings("default",160,60,15,80);
	}
	else if(level.Wave>=16 && level.Wave<20)
	{
		level.wave_bot_amount["default"] += 2;
		level.wave_bot_amount["dog"] = 0;
    	level.wave_bot_amount["jugger"] = 0;

		pix\server\_wave::setupWaveBotSettings("default",220,70,15,100);
	}
	else if(level.Wave>=20 && level.Wave<30)
	{
		level.wave_bot_amount["default"] += 2;
		level.wave_bot_amount["dog"] = 0;
    	level.wave_bot_amount["jugger"] = 0;

		pix\server\_wave::setupWaveBotSettings("default",260,70,15,100);
	}
	else if(level.Wave>=30 && level.Wave<40)
	{
		level.wave_bot_amount["default"] += 2;
		level.wave_bot_amount["dog"] = 0;
    	level.wave_bot_amount["jugger"] = 0;

		pix\server\_wave::setupWaveBotSettings("default",300,120,30,150);
	}
	else if(level.Wave>=40 && level.Wave<50)
	{
		level.wave_bot_amount["default"] += 2;
		level.wave_bot_amount["dog"] = 0;
    	level.wave_bot_amount["jugger"] = 0;

		pix\server\_wave::setupWaveBotSettings("default",420,200,50,250);
	}
	else if(level.Wave>=50)
	{
		level.wave_bot_amount["default"] = 600;
		level.wave_bot_amount["dog"] = 0;
    	level.wave_bot_amount["jugger"] = 0;

		pix\server\_wave::setupWaveBotSettings("default",450,220,60,270);
	}
	else
	{
		reset_wave_scheme_settings("default");
	}
}

setup_dog_bots()
{
    if(level.Wave>=4 && level.Wave<=10)
	{
		level.wave_bot_amount["dog"] = 2;
		pix\server\_wave::setupWaveBotSettings("dog",140,50,5,100);
	}
	else if(level.Wave>10 && level.Wave<16)
	{
		level.wave_bot_amount["dog"] = 4;
		pix\server\_wave::setupWaveBotSettings("dog",180,50,5,100);
	}
	else if(level.Wave>=16 && level.Wave<20)
	{
		level.wave_bot_amount["dog"] = 6;
		pix\server\_wave::setupWaveBotSettings("dog",220,80,10,140);
	}
	else if(level.Wave>=20 && level.Wave<30)
	{
		level.wave_bot_amount["dog"] = 8;
		pix\server\_wave::setupWaveBotSettings("dog",260,80,10,140);
	}
	else if(level.Wave>=30 && level.Wave<40)
	{
		level.wave_bot_amount["dog"] = 10;
		pix\server\_wave::setupWaveBotSettings("dog",300,100,15,160);
	}
	else if(level.Wave>=40 && level.Wave<50)
	{
		level.wave_bot_amount["dog"] = 12;
		pix\server\_wave::setupWaveBotSettings("dog",340,120,20,180);
	}
	else if(level.Wave>=50)
	{
		level.wave_bot_amount["dog"] = 16;
		pix\server\_wave::setupWaveBotSettings("dog",340,120,20,180);
	}
	else
	{
		reset_wave_scheme_settings("dog");
	}
}

setup_jugger_bots()
{
    if(level.Wave==10||level.Wave==14||level.Wave==17)
	{
		level.wave_bot_amount["jugger"] = 2;
		pix\server\_wave::setupWaveBotSettings("jugger",3600,150,5,100);
	}
	else if(level.Wave==20||level.Wave==25||level.Wave==28)
	{
		level.wave_bot_amount["jugger"] = 4;
		pix\server\_wave::setupWaveBotSettings("jugger",4200,180,10,120);
	}
	else if(level.Wave==30||level.Wave==34||level.Wave==37)
	{
		level.wave_bot_amount["jugger"] = 6;
		pix\server\_wave::setupWaveBotSettings("jugger",4400,220,15,150);
	}
	else if(level.Wave==40||level.Wave==44||level.Wave==48)
	{
		level.wave_bot_amount["jugger"] = 8;
		pix\server\_wave::setupWaveBotSettings("jugger",4600,250,20,180);
	}
	else if(level.Wave>=50)
	{
		level.wave_bot_amount["jugger"] = 12;
		pix\server\_wave::setupWaveBotSettings("jugger",4800,280,20,200);
	}
	else
	{
		reset_wave_scheme_settings("jugger");
	}
}


reset_wave_scheme_settings(type)
{
	switch(type)
	{
		case "default":
			level.wave_bot_amount["default"] = 0;
			pix\server\_wave::setupWaveBotSettings("default",120,50,5,80);
		break;

		case "dog":
			level.wave_bot_amount["dog"] = 0;
			pix\server\_wave::setupWaveBotSettings("dog",140,50,5,100);
		break;

		case "jugger":
			level.wave_bot_amount["jugger"] = 0;
			pix\server\_wave::setupWaveBotSettings("jugger",3600,150,5,100);
		break;

		default:
			level.wave_bot_amount["default"] = 0;
			level.wave_bot_amount["dog"] = 0;
			level.wave_bot_amount["jugger"] = 0;
			pix\server\_wave::setupWaveBotSettings("default",120,50,5,80);
			pix\server\_wave::setupWaveBotSettings("dog",140,50,5,100);
			pix\server\_wave::setupWaveBotSettings("jugger",3600,150,5,100);
		break;
	}
}

//Check for valid wave scheme
isValidWaveScheme(scheme)
{
    for(i=0;i<level.wave_schemes.size;i++)
    {
        if(level.wave_schemes[i]==scheme)
        {
            return true;
        }
    }
    return false;
}