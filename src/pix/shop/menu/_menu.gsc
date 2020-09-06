#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

setupMenuForPlayer()
{
    self.Menu = [];
    self.Scroller = [];

    self.ShopMenuOpened = false;
    self.ShopMenuType = "";
}


openShopMenu(type)
{
    if(self.ShopMenuOpened)
    {
        iprintln("^1ERROR: Menu Already Opened!");
        return;
    }

    self.ShopMenuType = type;
    self.ShopMenuOpened = true;

    self shopMenuCreateBackground();

    while(self.ShopMenuOpened)
    {
        self freezeControls(true);
        if(self AttackButtonPressed())
        {
            iprintln("Scroll");
            wait 0.170;
        }
        if(self AdsButtonPressed())
        {
            iprintln("Scroll");
            wait 0.170;
        }
        if(self UseButtonPressed())
        {
            iprintln("select");
            wait .4;
        }
        if(self MeleeButtonPressed())
        {
            self closeShopMenu();
            wait .4;
        }
        wait 0.05;
    }
}

closeShopMenu()
{
    self shopMenuDestroyBackground();

    self.ShopMenuOpened = false;
    self freezeControls(false);
}




shopMenuCreateBackground()
{
    self.Hud["menu_BG"] = createRectangle("CENTER","CENTER",0,0,250,150,(0.5,0.5,0.5),1,"white");
    self.Hud["menu_BG"] elemSetSort(1);

    self.Hud["menu_Title"] = createText("hudBig",1.0,"CENTER","TOP",0,138,(1,1,1),1,(0,0,0),0,"TEST TITLE");
    self.Hud["menu_Title"] elemSetSort(7);

    self.Hud["Stencil_Base"] = createShaderBasic("fullscreen","fullscreen",0,0,640,480,"xpbar_stencilbase",(1,1,1),1);
    self.Hud["Stencil_Base"] elemSetSort(0);

    self.Hud["Fog_Scroll_1"] = createRectangle("CENTER","CENTER",0,0,1708,480,(0.85,0.85,0.85),1,"mw2_popup_bg_fogscroll");
    self.Hud["Fog_Scroll_1"].min_x = -140;
    self.Hud["Fog_Scroll_1"].max_x = 140;
    self.Hud["Fog_Scroll_1"].move_direction = "left";
    self.Hud["Fog_Scroll_1"].x = 140;
    self.Hud["Fog_Scroll_1"] elemSetSort(4);
    
    self.Hud["Fog_Stencil_1"] = createRectangle("CENTER","CENTER",self.Hud["Fog_Scroll_1"].x,self.Hud["Fog_Scroll_1"].y,self.Hud["Fog_Scroll_1"].width,self.Hud["Fog_Scroll_1"].height,(1,1,1),0.75,"mw2_popup_bg_fogstencil");
    self.Hud["Fog_Stencil_1"] elemSetSort(2);
    
    self.Hud["Fog_Scroll_2"] = createRectangle("CENTER","CENTER",0,0,1708,480,(0.85,0.85,0.85),1,"mw2_popup_bg_fogscroll");
    self.Hud["Fog_Scroll_2"].min_x = -140;
    self.Hud["Fog_Scroll_2"].max_x = 140;
    self.Hud["Fog_Scroll_2"].move_direction = "right";
    self.Hud["Fog_Scroll_2"].x = -140;
    self.Hud["Fog_Scroll_2"] elemSetSort(5);
    
    self.Hud["Fog_Stencil_2"] = createRectangle("CENTER","CENTER",self.Hud["Fog_Scroll_2"].x,self.Hud["Fog_Scroll_2"].y,self.Hud["Fog_Scroll_2"].width,self.Hud["Fog_Scroll_1"].height,(1,1,1),0.75,"mw2_popup_bg_fogstencil");
    self.Hud["Fog_Stencil_2"] elemSetSort(3);

    self.Hud["Corner_Glow"] = createRectangle("CENTER","CENTER",25,15,300,120,(1,1,1),0,"mockup_bg_glow");
    self.Hud["Corner_Glow"] elemSetSort(6);
    self.Hud["Corner_Glow"] thread elemGlow(2);

    self.Hud["Fog_Scroll_1"] thread doFogAnimation(self.Hud["Fog_Stencil_1"]);
    wait .2;
    self.Hud["Fog_Scroll_2"] thread doFogAnimation(self.Hud["Fog_Stencil_2"]);
}

shopMenuDestroyBackground()
{
    self.Hud["menu_BG"] destroy();
    self.Hud["menu_Title"] destroy();
    self.Hud["Corner_Glow"] destroy();
    self.Hud["Stencil_Base"] destroy();
    self.Hud["Fog_Stencil_1"] destroy();
    self.Hud["Fog_Scroll_1"] destroy();
    self.Hud["Fog_Stencil_2"] destroy();
    self.Hud["Fog_Scroll_2"] destroy();
}


doFogAnimation(fog_stencil)
{
    while(isDefined(self))
    {
        if(self.move_direction=="left")
        {
            pos = self.min_x;
        }
        else
        {
            pos = self.max_x;
        }
        self elemMoveOverTimeX(32,pos);
        fog_stencil elemMoveOverTimeX(32,pos);
        wait 32;
        if(self.x <= self.min_x)
        {
            self.move_direction = "right";
        }
        if(self.x >= self.max_x)
        {
            self.move_direction = "left";
        }
    }
}