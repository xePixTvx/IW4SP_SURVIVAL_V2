#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\player\_hud;

//Directly set a players armor
setPlayerArmor(value)
{
    if(value>500)
    {
        value = 500;
    }
    self.Armor = value;
    self notify("armor_update");
}

//Add a specific amount to a players armor
givePlayerArmor(value)
{
    total = self.Armor + value;
    if(total>500)
    {
        self setPlayerArmor(500);
        iprintlnBold("^4Max Armor");
        return;
    }
    self thread ArmorNotify(value,"+",(0,0,1));
    self.Armor += value;
    self notify("armor_update");
}

//Monitor Player Armor Damage
monitor_player_armor()//test damage with --- self doDamage(50,self.origin);
{
    self endon("disconnect");
    self endon("death");
    for(;;)
    {
        self waittill("damage",damage);
        if(self.Armor>0)
        {
            remaining_armor = self.Armor - damage;
            self.health     = self.maxHealth;
            if(remaining_armor>0)
            {
                self.Armor -= damage;
            }
            else
            {
                self.Armor = 0;
            }
        }
        self notify("armor_update");
    }
}