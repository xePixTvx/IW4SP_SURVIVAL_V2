#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

addWeaponShop(pos,angles,model,icon)
{
    if(!isDefined(level.shop_info))
    {
        level.shop_info = [];
    }
    level.shop_info["weapon"] = spawnStruct();
    level.shop_info["weapon"].pos = pos;
    level.shop_info["weapon"].angles = angles;
    level.shop_info["weapon"].model = model;
    level.shop_info["weapon"].headIcon = icon;
    level.shop_info["weapon"].lowMsg = "Weapon Shop LowMsg Test";
    //level.shop_info["weapon"].mainFunction = ::shop_refill_ammo_main;
}