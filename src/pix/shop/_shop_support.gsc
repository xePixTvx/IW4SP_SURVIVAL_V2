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
    level.shop_info["support"].lowMsg = "Support Shop LowMsg Test";
    //level.shop_info["weapon"].mainFunction = ::shop_refill_ammo_main;
}