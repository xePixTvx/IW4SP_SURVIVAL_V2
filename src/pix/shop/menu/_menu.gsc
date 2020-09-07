#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\shop\menu\_menu_struct;

UNLM_SCROLL_MAX = 6;
UNLM_SCROLL_MAX_HALF = 3;
UNLM_SCROLL_MAX_HALF_ONE = 4;

setupMenuForPlayer()
{
    self.Menu = [];
    self.Scroller = [];

    self.ShopMenuOpened = false;
    self.ShopMenuType = "";

    self loadMenuStruct();
}

openShopMenu(type)
{
    if(self.ShopMenuOpened)
    {
        iprintln("^1ERROR: Menu Already Opened!");
        return;
    }
    self thread closeShopMenu_on_notify();
    self pix\player\_lowerMsg::hideLowerMsg();
    self.ShopMenuType = type;
    self.ShopMenuOpened = true;
    self.CurrentMenu = "main_"+type;
    self.Scroller[self.CurrentMenu] = 0;

    self shopMenuCreateBackground();
    self loadShopMenu(self.CurrentMenu);

    while(self.ShopMenuOpened)
    {
        self freezeControls(true);
        if(self AttackButtonPressed())
        {
            self.Scroller[self.CurrentMenu] ++;
            self scrollMenuUpdate();
            wait 0.170;
        }
        if(self SecondaryOffHandButtonPressed())
        {
            self.Scroller[self.CurrentMenu] --;
            self scrollMenuUpdate();
            wait 0.170;
        }
        if(self UseButtonPressed())
        {
            if(!self.Menu[self.CurrentMenu].menuLoader[self.Scroller[self.CurrentMenu]])
            {
                func = self.Menu[self.CurrentMenu].func[self.Scroller[self.CurrentMenu]];
                input1 = self.Menu[self.CurrentMenu].input1[self.Scroller[self.CurrentMenu]];
                input2 = self.Menu[self.CurrentMenu].input2[self.Scroller[self.CurrentMenu]];
                input3 = self.Menu[self.CurrentMenu].input3[self.Scroller[self.CurrentMenu]];
                self thread [[func]](input1,input2,input3);
            }
            else
            {
                self loadShopMenu(self.Menu[self.CurrentMenu].input1[self.Scroller[self.CurrentMenu]]);
            }
            wait .4;
        }
        if(self MeleeButtonPressed())
        {
            if(self.Menu[self.CurrentMenu].parent=="Exit")
            {
                self notify("shopMenu_close");
            }
            else
            {
                self loadShopMenu(self.Menu[self.CurrentMenu].parent);
            }
            wait .4;
        }
        wait 0.05;
    }
}

closeShopMenu_on_notify()
{
    self waittill_any("death","shopMenu_close");
    self destroyMenuText();
    self shopMenuDestroyBackground();

    self.ShopMenuOpened = false;
    self freezeControls(false);
    self pix\player\_lowerMsg::showLowerMsg();
}

shopMenuCreateBackground()
{
    self.Hud["menu_BG"] = createRectangle("CENTER","CENTER",0,0,250,150,(0.5,0.5,0.5),1,"white");
    self.Hud["menu_BG"] elemSetSort(1);

    self.Hud["menu_Title"] = createText("hudBig",1.0,"CENTER","TOP",0,138,(1,1,1),1,(0,0,0),0,"");
    self.Hud["menu_Title"] elemSetSort(7);

    self.Hud["Select_Bar"] = createRectangle("CENTER","TOP",0,162,250,20,(0,0,0),1,"menu_setting_selection_bar");
    self.Hud["Select_Bar"] elemSetSort(7);

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
    self.Hud["Select_Bar"] destroy();
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

loadShopMenu(menu)
{
    self destroyMenuText();
    self.CurrentMenu = menu;
    self loadMenuStruct();
    if(!isDefined(self.Scroller[self.CurrentMenu]))
    {
        self.Scroller[self.CurrentMenu] = 0;
    }
    self.Hud["menu_Title"] setText(self.Menu[self.CurrentMenu].title);
    self createMenuText();
    self scrollMenuUpdate();
}

destroyMenuText()
{
    if(isDefined(self.Hud["menu_Text"]))
    {
        text_elem_array = getArrayKeys(self.Hud["menu_Text"]);
        for(i=0;i<text_elem_array.size;i++)
        {
            self.Hud["menu_Text"][text_elem_array[i]] destroy();
        }
    }
}

createMenuText()
{
    self.Hud["menu_Text"] = [];
    for(i=0;i<UNLM_SCROLL_MAX;i++)
    {
        self.Hud["menu_Text"][i] = createText("default",1.4,"LEFT","TOP",-120,(self.Hud["menu_Title"].y + 23) + (18 * i),(1,1,1),1,(0,0,0),0,"");
        self.Hud["menu_Text"][i] elemSetSort(10);
    }
}

scrollMenuUpdate()
{
    if(self.Scroller[self.CurrentMenu]<0)
    {
        self.Scroller[self.CurrentMenu] = self.Menu[self.CurrentMenu].text.size-1;
    }
    if(self.Scroller[self.CurrentMenu]>self.Menu[self.CurrentMenu].text.size-1)
    {
        self.Scroller[self.CurrentMenu] = 0;
    }

    if(!isDefined(self.Menu[self.CurrentMenu].text[self.Scroller[self.CurrentMenu]-UNLM_SCROLL_MAX_HALF])||(self.Menu[self.CurrentMenu].text.size<=UNLM_SCROLL_MAX))
    {
        for(i=0;i<UNLM_SCROLL_MAX;i++)
        {
            if(isDefined(self.Menu[self.CurrentMenu].text[i]))
            {
                self.Hud["menu_Text"][i] setText(self.Menu[self.CurrentMenu].text[i]);
            }
            else
            {
                self.Hud["menu_Text"][i] setText("");
            }
        }
        self.Hud["Select_Bar"] elemMoveOverTimeY(0.170,162+(18*self.Scroller[self.CurrentMenu]));
    }
    else
    {
        if(isDefined(self.Menu[self.CurrentMenu].text[self.Scroller[self.CurrentMenu]+UNLM_SCROLL_MAX_HALF]))
        {
            PIX = 0;
            for(i=self.Scroller[self.CurrentMenu]-UNLM_SCROLL_MAX_HALF;i<self.Scroller[self.CurrentMenu]+UNLM_SCROLL_MAX_HALF_ONE;i++)
            {
                if(isDefined(self.Menu[self.CurrentMenu].text[i]))
                {
                    self.Hud["menu_Text"][PIX] setText(self.Menu[self.CurrentMenu].text[i]);
                }
                else
                {
                    self.Hud["menu_Text"][PIX] setText("");
                }
                PIX ++;
            }
            self.Hud["Select_Bar"] elemMoveOverTimeY(0.170,162+(18*UNLM_SCROLL_MAX_HALF));
        }
        else
        {
            for(i=0;i<UNLM_SCROLL_MAX;i++)
            {
                self.Hud["menu_Text"][i] setText(self.Menu[self.CurrentMenu].text[self.Menu[self.CurrentMenu].text.size+(i-UNLM_SCROLL_MAX)]);
            }
            self.Hud["Select_Bar"] elemMoveOverTimeY(0.170,(162+(18*((self.Scroller[self.CurrentMenu]-self.Menu[self.CurrentMenu].text.size)+UNLM_SCROLL_MAX))));
        }
    }
}
