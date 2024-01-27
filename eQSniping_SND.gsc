#include maps\mp\gametypes\_hud_util; // For createFontString

init()
{
    level thread onplayerconnect();
	info_text();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
    }
}


info_text()
{
    website = level createServerFontString( "Objective", 0.75 );
	website setPoint( "RIGHT", "RIGHT", 0, -120 );
	website setText("^5eQualize. ^7Sniping");
}

debug(text)
{
	self iPrintLnBold(text);
	wait 1;
}