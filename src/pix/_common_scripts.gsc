#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;

//Create Text Elem for Client
createText(font,fontscale,align,relative,x,y,color,alpha,glowColor,glowAlpha,text)
{
    textElem = self CreateClientFontString(font,fontscale);
    textElem setPoint(align,relative,x,y);
    textElem.sort             = 0;
    textElem.type             = "text";
    textElem.color            = color;
    textElem.default_color    = color;
    textElem.alpha            = alpha;
    textElem.glowColor        = glowColor;
    textElem.glowAlpha        = glowAlpha;
    if(isDefined(text))
    {
        textElem setText(text);
    }
    textElem.hideWhenInMenu = false;
    return textElem;
}

//Create Text Elem for Server
createServerText(font,fontscale,align,relative,x,y,color,alpha,glowColor,glowAlpha,text)
{
    textElem = createServerFontString(font,fontscale);
    textElem setPoint(align,relative,x,y);
    textElem.sort          = 0;
    textElem.type          = "text";
    textElem.color         = color;
    textElem.default_color = color;
    textElem.alpha         = alpha;
    textElem.glowColor     = glowColor;
    textElem.glowAlpha     = glowAlpha;
    if(isDefined(text))
    {
        textElem setText(text);
    }
    textElem.hideWhenInMenu = false;
    return textElem;
}

//Create Shader/Texture Elem for Client
createRectangle(align,relative,x,y,width,height,color,alpha,shadero)
{
    rect_elem               = newClientHudElem(self);
    rect_elem.width         = width;
    rect_elem.height        = height;
    rect_elem.align         = align;
    rect_elem.relative      = relative;
    rect_elem.xOffset       = 0;
    rect_elem.yOffset       = 0;
    rect_elem.children      = [];
    rect_elem.color         = color;
    rect_elem.default_color = color;
    if(isDefined(alpha))
    {
        rect_elem.alpha = alpha;
    }
    else
    {
        rect_elem.alpha = 1;
    }
    rect_elem setShader(shadero,width,height);
    rect_elem.hidden = false;
    rect_elem.sort            = 0;
    rect_elem setPoint(align,relative,x,y);
    return rect_elem;
}

//Create Old Shool/Basic Shader for Client --- setPoint not used
createShaderBasic(h_aling,v_aling,x,y,width,height,shader,color,alpha)
{
    basic_elem           = newClientHudElem(self);
    basic_elem.x         = x;
    basic_elem.y         = y;
    basic_elem.horzAlign = h_aling;
    basic_elem.vertAlign = v_aling;
    basic_elem setShader(shader,width,height);
    basic_elem.color         = color;
    basic_elem.default_color = color;
    basic_elem.alpha         = alpha;
    return basic_elem;
}

//Elem Functions
elemFadeOverTime(time,alpha)
{
    self fadeovertime(time);
    self.alpha = alpha;
}
elemMoveOverTimeY(time,y)
{
    self moveovertime(time);
    self.y = y;
}
elemMoveOverTimeX(time,x)
{
    self moveovertime(time);
    self.x = x;
}
elemMoveOverTimeAll(time,pos)
{
    self moveovertime(time);
    self.x = pos;
    self.y = pos;
}
elemScaleOverTime(time,width,height)
{
    self scaleovertime(time,width,height);
    self.width  = width;
    self.height = height;
}
elemSetSort(val)
{
    self.sort = val;
}
elemGlow(time)
{
    self endon("end_glow");
    while(isDefined(self))
    {
        self fadeOverTime(time);
        self.alpha = randomFloatRange(0.3,1);
        wait time;
    }
}
elemBlink()
{
    self notify("Update_Blink");
    self endon("Update_Blink");
    while(isDefined(self))
    {
        self elemFadeOverTime(.3,1);
        wait .3;
        self elemFadeOverTime(.3,0.3);
        wait .3;
    }
}
//------------------------------------------------------------------------------------------------------


//Platform Checks
isConsole()
{
    if(isXbox()||isPs3())
    {
        return true;
    }
    return false;
}
isXbox()
{
    if(level.xenon)
    {
        return true;
    }
    return false;
}
isPs3()
{
    if(level.ps3)
    {
        return true;
    }
    return false;
}

//Simple Test Function
Test()
{
	iprintln("^1TEST");
}


//Host Check
isHostPlayer()
{
	if(self GetEntityNumber()==0)
	{
		return true;
	}
	return false;
}

//Get Player Array
getPlayers()
{
	return level.players;
}

//Get Host Player
getHost()
{
    foreach(player in level.players)
    {
        if(player isHostPlayer())
        {
            return player;
        }
    }
}

//Get Player 1(Host)
getPlayer1()
{
	return getPlayers()[0];//or level.player1
}

//Get Player 2
getPlayer2()
{
	if(getPlayers().size<1)
	{
		return undefined;
	}
	return getPlayers()[1];//or level.player2
}

//Check if string is in array
stringInArray(ar,string)
{
    array = [];
    array = ar;
    for(i=0;i<array.size;i++)
    {
        if(array[i]==string)
        {
            return true;
        }
    }
    return false;      
}


//Convert int to bool
intToBool(i)
{
	if(i>=1)
	{
		return true;
	}
	return false;
}

//Convert bool to int
boolToInt(b)
{
	if(b)
	{
		return 1;
	}
	return 0;
}

//Get Player Cursor Position
getCursorPos(multiplier)
{
	if(!isDefined(multiplier))
	{
		multiplier = 1000000;
	}
    angle_forward = AnglesToForward(self getPlayerAngles());
    multiplied_vector3 = angle_forward * multiplier;
    //dont use self getTagOrigin("tag_eye")
    return BulletTrace(self getEye(),multiplied_vector3,false,self)["position"];
}

//Delete or Destroy Entity after some time
removeEntityOverTime(time,type)
{
	if(!isDefined(type))
	{
		type = "delete";
	}
    wait time;
    if(type == "delete")
    {
        self delete();
    }
    else
    {
        self destroy();
    }
}

//notify entity after some time
ent_notify_after_time_period(waitTime,notification,end)
{
    if(isDefined(end))
    {
        self endon(end);
    }
    self endon(notification);
    wait waitTime;
    self notify(notification);
}

//Remove All Placed Weapons on current map
removePlacedWeapons()
{
	ents = GetEntArray();
	for(i=0;i<ents.size;i++)
	{
		if((isDefined(ents[i].classname)) && (getSubStr(ents[i].classname,0,7)=="weapon_"))
		{
			ents[i] delete();
		}
	}
}

//Setup Minimap
minimap_setup(image)
{
	setSavedDvar("compass","1");
	setSavedDvar("ui_hidemap","0");
	level.so_compass_zoom = "close";
	setSavedDvar("compassmaxrange",1500);
	maps\_compass::setupMiniMap(image);
	if(getDvarInt("specialops")==0)
	{
		level.survival_hud_main_y = 0;
	}
	else
	{
		level.survival_hud_main_y = 75;
	}
}

//Get Difficulty --- 1 = regular --- 2 = hardened --- 3 = veteran
getIW4Difficulty()
{
    diffi = level.gameskill;
    if(diffi<1||diffi>3)
    {
        iprintln("^1UNKNOWN DIFFICULTY!");
        return;
    }
    return diffi;
}

//Create a Trigger
/*createTrigger(origin,width,height,cursorHint,string)
{
    trig = spawn("trigger_radius", origin, 1, width, height);
    trig setCursorHint(cursorHint, trig);
    trig setHintString( string );
    trig setvisibletoall();
    return trig;
}*/



printToConsole(text,lineBreak)
{
    if(!isDefined(lineBreak))
    {
        lineBreak = true;
    }
    /#
    if(lineBreak)
    {
        println(text);
    }
    else
    {
        print(text);
    }
    #/
}