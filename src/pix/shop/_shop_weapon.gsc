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
    level.shop_info["weapon"].lowMsg = "Press ^3[{+activate}]^7 to Open Weapon Shop!";
    level.shop_info["weapon"].unlock_wave = 5;
    level.shop_info["weapon"].mainFunction = ::weapon_shop_main;
}

weapon_shop_main(lowMsg,unlock_wave)
{
    if(level.Wave<unlock_wave)
    {
        self pix\player\_lowerMsg::doLowerMsg("^1Unlocked at Wave " + unlock_wave);
    }
    else
    {
        self pix\player\_lowerMsg::doLowerMsg(lowMsg);
        if(self UseButtonPressed() && !self.ShopMenuOpened)
        {
            self thread pix\shop\menu\_menu::openShopMenu("weapon");
            return true;
        }
    }
    return false;
}

buy_refillAmmo()
{
    if(!self pix\player\_money::hasPlayerEnoughMoney(level.price["refillAmmo"]))
    {
        iprintlnBold("^1Not Enough Money!");
        return;
    }
    self pix\player\_money::takePlayerMoney(level.price["refillAmmo"]);
    weapons = self GetWeaponsListAll();
	foreach(wep in weapons)
	{
		self GiveMaxAmmo(wep);
	}
    iprintlnBold("^2Ammo Refilled!");
}