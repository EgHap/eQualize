#include maps\mp\gametypes\_hud_util;

init()
{
    level.AxisCount = 0;
    level.AlliesCount = 0;

    thread InitHuds();
}

InitHuds()
{
    level.eQualizeText = level CreateServerFontString("small", 1);
    level.eQualizeText setPoint("TOPLEFT", "TOPLEFT", 0, 110);
    level.eQualizeText.label = &"^4eQualize: ^7";

    level.OthersText = level CreateServerFontString("small", 1);
    level.OthersText setPoint("TOPLEFT", "TOPLEFT", 0, 120);
    level.OthersText.label = &"^7Others: ^7";

    while (true)
    {
        eQualizeTeamCount = AxisTeam();
        OthersTeamCount = AlliesTeam();
        level.eQualizeText setValue(eQualizeTeamCount);
        level.OthersText setValue(OthersTeamCount);
        wait 0.5;
    }
}

AxisTeam()
{
    level.AxisCount = 0;

    foreach (player in level.players)
    {
        if (isDefined(player) && player.team == "axis" && isAlive(player))
        {
            level.AxisCount++;
        }
    }
    return level.AxisCount;
}

AlliesTeam()
{
    level.AlliesCount = 0;

    foreach (player in level.players)
    {
        if (isDefined(player) && player.team == "allies" && isAlive(player))
        {
            level.AlliesCount++;
        }
    }
    return level.AlliesCount;
}