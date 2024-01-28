#include maps\mp\gametypes\_hud_util;

init()
{
    level.onPlayerKilled = ::OnPlayerKilled;


    thread OnPlayerConnected();
    
	replaceFunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::AfterKillcam);
}

OnPlayerConnected()
{
    for(;;)
    {
        level waittill("connected", player);
        player.pers["highKS"] = 0;
        player.kd = 0;
		player thread DisplayHighestKD();
    }
}

DisplayHighestKD()
{
	self endon("disconnect");
    level endon("game_ended");
	self.topkd = self createFontString("small", 1);
    self.topkd setPoint("TOPRIGHT", "TOPRIGHT", 0, 10);
    self.topkd.label = &"^4Your KD: ^7";
    
    while(true)
    {
		if(level.players.size > 0 && isDefined(self.kd))
		{			
			self.topkd setValue(self.kd);
		}
        wait 0.5;
    }
}

UpdateKD()
{
    kd = (self.deaths > 0) ? (self.kills / self.deaths) : self.kills;
	self.kd = kd;
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
    eAttacker UpdateKD();
    self UpdateKD();
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
