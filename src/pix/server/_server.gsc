#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\server\_hud;

init()
{
    level.Wave = 0;
    level.IntermissionTime = 40;

    level.price = [];
    level.price["refillAmmo"] = 800;

    level thread createServerHud();
    level thread pix\bot\_bot::init_bot();
    level thread pix\server\_wave::init_wave();
}