#include maps\mp\gametypes\_hud_util;

init()
{
    level.onPlayerKilled = ::OnPlayerKilled;


    thread OnPlayerConnected();
    thread DisplayHighestKD();
    
	replaceFunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::AfterKillcam);
}

OnPlayerConnected()
{
    for(;;)
    {
        level waittill("connected", player);
        player.pers["highKS"] = 0;
        player.pers["KD"] = 0;

    }
}

DisplayHighestKD()
{

    level.topkd = level createServerFontString("small", 1);
    level.topkd setPoint("TOPRIGHT", "TOPRIGHT", 0, 10);

    for(;;)
    {
        if(level.players.size > 0)
        {
            highestKDPlayer = GetPlayerWithHighestKD();
            level.topkd setText("^5TOP KD: " + highestKDPlayer.Name + " - " + highestKDPlayer.pers["KD"]);
        }
        wait 0.05;
    }
}

GetPlayerWithHighestKD()
{

        highestKDPlayer = level.players[0];

        foreach (player in level.players)
        {
            if (player.pers["KD"] > highestKDPlayer.pers["KD"])
            {
                highestKDPlayer = player;
            }
        }
    
    return highestKDPlayer;
}
UpdateTopKD()
{
    if(level.players.size > 0)
    foreach (player in level.players)
    {
        kd = (player.deaths > 0) ? (player.kills / player.deaths) : player.kills;

        player.pers["KD"] = kd;
    }
}

AfterKillcam()
{
    level waittill("final_killcam_done");
	DisplayPlayerSummary();
    wait 15;
    cmdexec("map_rotate");
    return true;
}

OnPlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, lifeId)
{
    if (eAttacker.pers["cur_kill_streak"] > eAttacker.pers["highKS"])
    {
        eAttacker.pers["highKS"] = eAttacker.pers["cur_kill_streak"];
    }
    UpdateTopKD();
}

DisplayPlayerSummary()
{
    playerList = [];
	
    popupBackground = level CreateServerIcon("gfx/white", 1100, 900);
    popupBackground SetPoint("CENTER", "CENTER", 0, 0);
	popupBackground.alpha = .5;
    popupBackground SetShader("black", 600, 300);
    popupBackground FadeOverTime(15);
	
    headerFont = level createServerFontString("small", 1.5);
    headerFont setPoint("TOPCENTER", "TOPCENTER", 0, 100);
    headerFont setText("^5Player                          Highest Killstreak");

    foreach(player in level.players)
    {
        playerList[playerList.size] = player;
    }
    playerList = BubbleSortPlayers(playerList);

    for (i = 0; i < playerList.size; i++)
    {
        player = playerList[i];
        rank = i + 1;

        hud_highKS = level createServerFontString("small", 1.5);
        hud_highKS setPoint("TOPCENTER", "TOPCENTER", 0, 130 + i * 20);
		if(rank < 6)
		{
			hud_highKS setText("^7" + player.Name + "\r                                                           " + player.pers["highKS"]);
		}
    }
}

BubbleSortPlayers(players)
{
    for (i = 0; i < players.size; i++)
    {
        for (j = 0; j < players.size - i - 1; j++)
        {
            if (players[j].pers["highKS"] < players[j + 1].pers["highKS"])
            {
                temp = players[j];
                players[j] = players[j + 1];
                players[j + 1] = temp;
            }
        }
    }
    return players;
}
