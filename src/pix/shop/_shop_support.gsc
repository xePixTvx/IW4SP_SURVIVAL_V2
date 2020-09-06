#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

addSupportShop(pos,angles,model,icon)
{
    if(!isDefined(level.shop_info))
    {
        level.shop_info = [];
    }
    level.shop_info["support"] = spawnStruct();
    level.shop_info["support"].pos = pos;
    level.shop_info["support"].angles = angles;
    level.shop_info["support"].model = model;
    level.shop_info["support"].headIcon = icon;
    level.shop_info["support"].lowMsg = "Press ^3[{+activate}]^7 to Open Support Shop!";
    level.shop_info["support"].unlock_wave = 8;
    level.shop_info["support"].mainFunction = ::support_shop_main;
}

support_shop_main(lowMsg,unlock_wave)
{
    if(level.Wave<unlock_wave)
    {
        self pix\player\_lowerMsg::doLowerMsg("^1Unlocked at Wave " + unlock_wave);
    }
    else
    {
        self pix\player\_lowerMsg::doLowerMsg(lowMsg);
    }
    if(self UseButtonPressed())
    {
        iprintln("^2YAY");
        //self thread shop_buy_refill_ammo();
        return true;
    }
    return false;
}

