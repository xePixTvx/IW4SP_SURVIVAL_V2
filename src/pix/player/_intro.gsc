#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include maps\_introscreen;
#include pix\_common_scripts;

//Do a simple flying intro(can be used on all maps)
intro_flying_default()
{
	self thread weapon_pullout();
	self freezeControls(true);
	if(toLower(getDvar("mapname"))=="airport")
	{
		zoomHeight = 120;
	}
	else
	{
		zoomHeight = 2000;
	}
	origin = self.origin;
	self PlayerSetStreamOrigin(origin);
	self.origin = origin+(0,0,zoomHeight);
	ent = Spawn("script_model",(69,69,69));
	ent.origin = self.origin;
	ent SetModel("tag_origin");
	ent.angles = self.angles;
	self PlayerLinkTo(ent,undefined,1,0,0,0,0);
	ent.angles = (ent.angles[0]+89,ent.angles[1],0);
	ent MoveTo(origin+(0,0,0),2,0,2);
	wait(1.00);
	wait(0.5);
	ent RotateTo((ent.angles[0]-89,ent.angles[1],0),0.5,0.3,0.2);
	wait(0.5);
	flag_set("pullup_weapon");
	self notify("intro_done");
	SetSavedDvar("compass",1);
	SetSavedDvar("ammoCounterHide","0");
	SetSavedDvar("hud_showstance","1");
	SetSavedDvar("actionSlotsHide","0");
	wait(0.2);
	self Unlink();
	self FreezeControls(false);
	self PlayerClearStreamOrigin();
	thread play_sound_in_space("ui_screen_trans_in",self.origin);
	wait(0.2);
	thread play_sound_in_space("ui_screen_trans_out",self.origin);
	wait(0.2);
	flag_set("introscreen_complete");
	wait(2);
	ent Delete();
	return true;
}