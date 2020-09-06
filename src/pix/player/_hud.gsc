#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

//Create Player Hud
createHud()
{
    self.Hud["Line"] = createRectangle("LEFT","CENTER",-527,208,420,1,(1,1,1),0,"line_horizontal");
    self.Hud["Line"].hideWhenInMenu = true;
	
	self.Hud["Money"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",-55,28,(1,1,1),0,(0.3,0.6,0.3),1);
	self.Hud["Money"].label = "$";
	self.Hud["Money"] setValue(self.Money);
    self.Hud["Money"] elemSetSort(20);
    self.Hud["Money"].hideWhenInMenu = true;

    self.Hud["Money_Notify"] = createText("objective",1.5,"CENTER","CENTER",0,-20,(0,1,0),0,(0,1,0),0);
    self.Hud["Money_Notify"].label = "+";
    self.Hud["Money_Notify"] setValue(0);
    self.Hud["Money_Notify"].hideWhenInMenu = true;
    self.money_update = 0;

    self.Hud["Headshot_Notify"] = createText("objective",1.5,"CENTER","CENTER",0,-38,(1,1,1),0,(0,1,0),0);
    self.Hud["Headshot_Notify"].label = "Headshot ^2+";
    self.Hud["Headshot_Notify"] setValue(0);
    self.Hud["Headshot_Notify"].hideWhenInMenu = true;
    self.headshot_update = 0;

    self.Hud["Armor"] = createText("objective",1.5,"BOTTOMLEFT","BOTTOMLEFT",-55,-5,(1,1,1),0,(0,0,1),1);
    self.Hud["Armor"].label = "Armor: ";
    self.Hud["Armor"] setValue(self.Armor);
    self.Hud["Armor"] elemSetSort(20);
    self.Hud["Armor"].hideWhenInMenu = true;

    self.Hud["Armor_Notify"] = createText("objective",1.5,"CENTER","CENTER",0,40,(0,0,1),0,(0,1,0),0);
    self.Hud["Armor_Notify"].label = "+";
    self.Hud["Armor_Notify"] setValue(0);
    self.Hud["Armor_Notify"].hideWhenInMenu = true;
    self.armor_update = 0;

    self thread monitor_player_armor_hud();
}

//Destroy Player Hud
destroyHud()
{
    self.Hud["Line"] destroy();
	self.Hud["Money"] destroy();
    self.Hud["Money_Notify"] destroy();
    self.Hud["Headshot_Notify"] destroy();
    self.Hud["Armor"] destroy();
    self.Hud["Armor_Notify"] destroy();
    self notify("player_hud_destroyed");
}

//Fade Player Hud
fadeHud(time,alpha)
{
    self.Hud["Line"] elemFadeOverTime(time,alpha);
    self.Hud["Money"] elemFadeOverTime(time,alpha);
    self.Hud["Armor"] elemFadeOverTime(time,alpha);//hmmmmm????
}




//Show Money Notify to Player
MoneyNotify(amount,label,color)
{
    self notify("money_notify");
    self endon("money_notify");
    self.money_update += amount;
    self.Hud["Money_Notify"].label = label;
    self.Hud["Money_Notify"].color = color;
    self.Hud["Money_Notify"] setValue(self.money_update);
    self.Hud["Money_Notify"].alpha = 1;
    wait .5;
    self.Hud["Money_Notify"] fadeOverTime(.4);
    self.Hud["Money_Notify"].alpha = 0;
    wait .4;
    self.money_update = 0;
}

//Show Headshot Money Notify to Player
HeadShotMoneyNotify(amount)
{
    self notify("headshot_notify");
    self endon("headshot_notify");
    self.headshot_update += amount;
    self.Hud["Headshot_Notify"].label = "Headshot ^2+";
    self.Hud["Headshot_Notify"].color = (1,1,1);
    self.Hud["Headshot_Notify"] setValue(self.headshot_update);
    self.Hud["Headshot_Notify"].alpha = 1;
    wait .5;
    self.Hud["Headshot_Notify"] fadeOverTime(.4);
    self.Hud["Headshot_Notify"].alpha = 0;
    wait .4;
    self.headshot_update = 0;
}

//Show Armor Notify to Player
ArmorNotify(amount,label,color)
{
    self notify("armor_notify");
    self endon("armor_notify");
    self.armor_update += amount;
    self.Hud["Armor_Notify"].label = label;
    self.Hud["Armor_Notify"].color = color;
    self.Hud["Armor_Notify"] setValue(self.armor_update);
    self.Hud["Armor_Notify"].alpha = 1;
    wait .5;
    self.Hud["Armor_Notify"] fadeOverTime(.4);
    self.Hud["Armor_Notify"].alpha = 0;
    wait .4;
    self.armor_update = 0;
}

//Monitor player armor counter hud
monitor_player_armor_hud()
{
    self endon("disconnect");
    self endon("death");
    self endon("player_hud_destroyed");
    for(;;)
    {
        self waittill("armor_update");
        if(self.Hud["Armor"].alpha==0)
        {
            if(self.Armor>0)
            {
                self.Hud["Armor"] elemFadeOverTime(.4,1);
            }
        }
        else
        {
            if(self.Armor<=0)
            {
                self.Hud["Armor"] elemFadeOverTime(.4,0);
            }
        }
        self.Hud["Armor"] setValue(self.Armor);
    }
}