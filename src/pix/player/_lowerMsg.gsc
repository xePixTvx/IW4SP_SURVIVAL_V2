#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

initPlayerLowerMsg()
{
    self.currentLowerMsg = "";
    self.Hud["lowermsg"] = createText("default",1.5,"CENTER","CENTER",0,100,(1,1,1),1,(0,0,0),0,self.currentLowerMsg);
    self.Hud["lowermsg"] elemSetSort(999);
}

doLowerMsg(text)
{
    if(self.currentLowerMsg!=text)
    {
        self.currentLowerMsg = text;
        self.Hud["lowermsg"] setText(self.currentLowerMsg);
    }
}

clearLowerMsg()
{
    if(self.currentLowerMsg!="")
    {
        self.currentLowerMsg = "";
        self.Hud["lowermsg"] setText(self.currentLowerMsg);
    }
}

hideLowerMsg()
{
    self.Hud["lowermsg"].alpha = 0;
}
showLowerMsg()
{
    self.Hud["lowermsg"].alpha = 1;
}