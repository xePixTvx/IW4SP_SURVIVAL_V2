#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

//Add Mortar Strike Settings --- used in the map files
addMortarStrike(bullet,type)
{
    level.MortarStrike = spawnStruct();
    level.MortarStrike.bullet = bullet;
    if(!isDefined(type))
    {
        level.MortarStrike.type = "default";
    }
    else
    {
        level.MortarStrike.type = type;
    }
}


//Buy and start mortar stuff
buy_mortar(bullet,price)
{
    if(self.has_mortar_strike)
    {
        iprintlnBold("^1You already have a Mortar Strike!");
        return;
    }
    if(!self pix\player\_money::hasPlayerEnoughMoney(price))
    {
        iprintlnBold("^1Not Enough Money!");
        return;
    }
	self pix\player\_money::takePlayerMoney(price);
    wait .5;
    self notify("shopMenu_close");
    self thread mortarStrike_main();//TMP!!!!!!
}


mortarStrike_main()
{
	iprintlnBold("^1Shoot to mark mortar location!");
	self.has_mortar_strike = true;
	wait .2;
	oldWeapon = self getCurrentWeapon();
    self giveWeapon("defaultweapon");
    wait 0.4;
	self freezeControls(false);
    self switchToWeapon("defaultweapon");
    wait 0.4;
	self endon("mortar_launched");
	for(;;)
	{
		self waittill("weapon_fired");
		if((self getCurrentWeapon() == "defaultweapon") && self.has_mortar_strike)
		{
			pos = self getCursorPos();
			self thread doMortar(pos);
			self.has_mortar_strike = false;
			self switchToWeapon(oldWeapon);
			self takeWeapon("defaultweapon");
			self notify("mortar_launched");
		}
		wait 0.05;
	}
}


//use level.MortarStrike.type for some plane flyover stuff
doMortar(pos)
{
    level thread pix\server\_hud::simpleServerNotifyMessage("Mortar Strike Incoming",3);
	wait 4;
    if(level.MortarStrike.bullet=="rpg"||level.MortarStrike.bullet=="rpg_player")
    {
        times = 15;
    }
    else
    {
        times = 8;
    }
	sky = pos + (0,0,2500);
	mortar = BulletTrace(pos,(pos+(0,0,-100000)),0,self)["position"];
    mortar += (0,0,400);
	wait .4;
	for(i=0;i<times;i++)
    {
        xM = randomint(250);
        yM = randomint(250);
        zM = randomint(40);
        magicBullet(level.MortarStrike.bullet,sky,mortar+(xM,yM,zM),self);
        wait 1;
    }
}