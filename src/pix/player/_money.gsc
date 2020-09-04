#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\player\_hud;

//Directly set a players money
setPlayerMoney(value)
{
    self.Money = value;
    self.Hud["Money"] setValue(self.Money);
}

//Add a specific amount to a players money
givePlayerMoney(value,headShotValue)
{
    if(isDefined(headShotValue))
    {
        self thread MoneyNotify(value,"+",(0,1,0));
        self thread HeadShotMoneyNotify(headShotValue);
        self.Money += value + headShotValue;
    }
    else
    {
        self thread MoneyNotify(value,"+",(0,1,0));
        self.Money += value;
    }
    self.Hud["Money"] setValue(self.Money);
}

//Remove a specific amount to a players money
takePlayerMoney(value)
{
    self thread MoneyNotify(value,"-",(1,0,0));
    endValue = self.Money - value;
    if(endValue<0)
    {
        self.Money = 0;
    }
    else
    {
        self.Money -= value;
    }
    self.Hud["Money"] setValue(self.Money);
}

//Check if player has enough money
hasPlayerEnoughMoney(price)
{
    if(self.Money>=price)
    {
        return true;
    }
    return false;
}