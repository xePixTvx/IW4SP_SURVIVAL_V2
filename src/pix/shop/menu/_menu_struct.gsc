#include common_scripts\utility;
#include maps\_utility;
#include maps\_debug;
#include maps\_hud_util;
#include pix\_common_scripts;

#include pix\shop\menu\_menu;

loadMenuStruct()
{
    self CreateMenu("main","Main Menu","Exit");
    self addOption(-1,"main","Option 1",::Test);
    self addOption(-1,"main","Option 2",::Test);
    self addOption(-1,"main","Option 3",::Test);
    self addOption(-1,"main","Option 4",::Test);
    self addOption(-1,"main","Option 5",::Test);
    self addOption(-1,"main","Option 6",::Test);
    self addOption(-1,"main","Option 7",::Test);
    self addOption(-1,"main","Option 8",::Test);
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