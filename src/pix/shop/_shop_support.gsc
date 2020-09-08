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
        if(self UseButtonPressed() && !self.ShopMenuOpened)
        {
            self thread pix\shop\menu\_menu::openShopMenu("support");
            return true;
        }
    }
    return false;
}

buy_armor(amount,price)
{
    if(!self pix\player\_money::hasPlayerEnoughMoney(price))
    {
        iprintlnBold("^1Not Enough Money!");
        return;
    }
    if(self.Armor>=500)
    {
        iprintlnBold("^4Max Armor");
        return;
    }
	self pix\player\_money::takePlayerMoney(price);
    self pix\player\_armor::givePlayerArmor(amount);
}

buy_weaponslot(price)
{
    if(self.max_weapons>=4)
	{
		iprintlnBold("^1Max Slots!");
		return;
	}
	if(!self pix\player\_money::hasPlayerEnoughMoney(price))
    {
        iprintlnBold("^1Not Enough Money!");
        return;
    }
	self pix\player\_money::takePlayerMoney(price);
	self.max_weapons ++;
    self pix\shop\menu\_menu_struct::loadMenuStruct();
	self pix\shop\menu\_menu::scrollMenuUpdate();
}

buy_fasterMovement(price)
{
    if(self.has_faster_movement)
    {
        iprintlnBold("^1You already have Faster Movement!");
        return;
    }
    if(!self pix\player\_money::hasPlayerEnoughMoney(price))
    {
        iprintlnBold("^1Not Enough Money!");
        return;
    }
	self pix\player\_money::takePlayerMoney(price);
    self setMoveSpeedScale(1.30);
    self thread fasterMovement_keepSpeedScale();
}
fasterMovement_keepSpeedScale()
{
    self notify("fasterMovement_keepSpeedScale_end");
    self endon("fasterMovement_keepSpeedScale_end");
    self.has_faster_movement = true;
    for(;;)
    {
        self setMoveSpeedScale(1.30);
        wait 2;
    }
}