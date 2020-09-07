#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\shop\menu\_menu;
#include pix\shop\_shop_weapon;

loadMenuStruct()
{
    self thread weaponShopStruct();
    self thread supportShopStruct();
}

weaponShopStruct()
{
    self CreateMenu("main_weapon","Weapon Shop","Exit");
    self addOption(-1,"main_weapon","Refill Ammo",::buy_refillAmmo);
        self addPrice(self getLatestShopMenuOptionAdded(),"main_weapon",level.price["refillAmmo"]);
    if(getWeaponShopItemCount("pistol")>0)
	{
        self loadMenu(-1,"main_weapon","Pistols","pist");
	}
	if(getWeaponShopItemCount("shotgun")>0)
	{
        self loadMenu(-1,"main_weapon","Shotguns","shot");
	}
	if(getWeaponShopItemCount("smg")>0)
	{
        self loadMenu(-1,"main_weapon","SMGs","smg");
	}
	if(getWeaponShopItemCount("assault_rifle")>0)
	{
        self loadMenu(-1,"main_weapon","Assault Rifles","ar");
	}
	if(getWeaponShopItemCount("lmg")>0)
	{
        self loadMenu(-1,"main_weapon","LMGs","lmg");
	}
	if(getWeaponShopItemCount("sniper")>0)
	{
        self loadMenu(-1,"main_weapon","Snipers","sn");
	}
	if(getWeaponShopItemCount("equipment")>0)
	{
        self loadMenu(-1,"main_weapon","Equipment","eq");
	}

    self CreateMenu("pist","Pistols","main_weapon");
    self CreateMenu("shot","Shotguns","main_weapon");
    self CreateMenu("smg","SMGs","main_weapon");
    self CreateMenu("ar","Assault Rifles","main_weapon");
    self CreateMenu("sn","Snipers","main_weapon");
    self CreateMenu("lmg","LMGs","main_weapon");
    self CreateMenu("eq","Equipment","main_weapon");
	for(i=0;i<level.weaponshop_items.size;i++)
	{
		if(level.weaponshop_items[i].type=="pistol")
		{
            self addOption(-1,"pist",level.weaponshop_items[i].string,::buy_Weapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price);
                self addPrice(self getLatestShopMenuOptionAdded(),"pist",level.weaponshop_items[i].price);
		}
        if(level.weaponshop_items[i].type=="shotgun")
        {
            self addOption(-1,"shot",level.weaponshop_items[i].string,::buy_Weapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price);
                self addPrice(self getLatestShopMenuOptionAdded(),"shot",level.weaponshop_items[i].price);
        }
        if(level.weaponshop_items[i].type=="smg")
        {
            self addOption(-1,"smg",level.weaponshop_items[i].string,::buy_Weapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price);
                self addPrice(self getLatestShopMenuOptionAdded(),"smg",level.weaponshop_items[i].price);
        }
        if(level.weaponshop_items[i].type=="assault_rifle")
        {
            self addOption(-1,"ar",level.weaponshop_items[i].string,::buy_Weapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price);
                self addPrice(self getLatestShopMenuOptionAdded(),"ar",level.weaponshop_items[i].price);
        }
        if(level.weaponshop_items[i].type=="lmg")
        {
            self addOption(-1,"lmg",level.weaponshop_items[i].string,::buy_Weapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price);
                self addPrice(self getLatestShopMenuOptionAdded(),"lmg",level.weaponshop_items[i].price);
        }
        if(level.weaponshop_items[i].type=="sniper")
        {
            self addOption(-1,"sn",level.weaponshop_items[i].string,::buy_Weapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price);
                self addPrice(self getLatestShopMenuOptionAdded(),"sn",level.weaponshop_items[i].price);
        }
        if(level.weaponshop_items[i].type=="equipment")
        {
            self addOption(-1,"eq",level.weaponshop_items[i].string,::buy_Weapon,level.weaponshop_items[i].id,level.weaponshop_items[i].price);
                self addPrice(self getLatestShopMenuOptionAdded(),"eq",level.weaponshop_items[i].price);
        }
	}
}

supportShopStruct()
{
    self CreateMenu("main_support","Support Shop","Exit");
    self addOption(-1,"main_support","Option 1",::Test);
    self addOption(-1,"main_support","Option 2",::Test);
    self addOption(-1,"main_support","Option 3",::Test);
    self addOption(-1,"main_support","Option 4",::Test);
}



CreateMenu(menu,title,parent)
{
    self.Menu[menu] = spawnStruct();
    self.Menu[menu].title = title;
    self.Menu[menu].parent = parent;
    self.Menu[menu].text = [];
    self.Menu[menu].func = [];
    self.Menu[menu].input1 = [];
    self.Menu[menu].input2 = [];
    self.Menu[menu].input3 = [];
    self.Menu[menu].menuLoader = [];
}
addOption(index,menu,text,func,inp1,inp2,inp3)
{
    if(index==-1)
    {
        index = self.Menu[menu].text.size;
    }
    self.Menu[menu].text[index] = text;
    self.Menu[menu].func[index] = func;
    self.Menu[menu].input1[index] = inp1;
    self.Menu[menu].input2[index] = inp2;
    self.Menu[menu].input3[index] = inp3;
    self.Menu[menu].menuLoader[index] = false;
}
addPrice(index,menu,value)
{
    self.Menu[menu].price[index] = value;
}
loadMenu(index,menu,text,inp1)
{
    if(index==-1)
    {
        index = self.Menu[menu].text.size;
    }
    self.Menu[menu].text[index] = text;
    self.Menu[menu].input1[index] = inp1;
    self.Menu[menu].menuLoader[index] = true;
}