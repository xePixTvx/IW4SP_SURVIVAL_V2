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


addWeaponShopItem(str,id,price,type)
{
	s = level.weaponshop_items.size;
	level.weaponshop_items[s] = spawnStruct();
	level.weaponshop_items[s].string = str;
	level.weaponshop_items[s].id = id;
	level.weaponshop_items[s].price = price;
	level.weaponshop_items[s].type = type;
	/*types
		assault_rifle
		smg
		lmg
		sniper
		shotgun
		pistol
		equipment
	*/
}
getWeaponShopItemCount(type)
{
	count = 0;
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type==type)
		{
			count ++;
		}
	}
	return count;
}

default_weaponshopSetup()
{
	level.weaponshop_items = [];
	thread pix\shop\_shop_weapon::addWeaponShopItem(&"WEAPON_DEFAULTWEAPON","defaultweapon",50,"pistol");
}

buy_Weapon(id,price)
{
	weapons = self GetWeaponsListAll();
	foreach(wep in weapons)
	{
		if(wep==id)
		{
			iprintlnBold("^1You already have that Weapon!");
			return;
		}
	}
	if(!self pix\player\_money::hasPlayerEnoughMoney(price))
    {
        iprintlnBold("^1Not Enough Money!");
        return;
    }
	self pix\player\_money::takePlayerMoney(price);
	if(isSubStr(id,"_akimbo"))
	{
		self giveWeapon(id,0,true);
	}
	else
	{
		self giveWeapon(id,0);
	}
	if(self getWeaponsListPrimaries().size > self.max_weapons)
	{
		self takeWeapon(self GetCurrentWeapon());
	}
	self freezeControls(false);
	self GiveMaxAmmo(id);
	self switchToWeapon(id);
}