#include maps\mp\gametypes\_hud_util;


init()
{
    print("loading eQualize Sniper");
    
    SetDvar("sv_enableDoubleTaps", 1);

    thread OnPlayerConnected();

    Advertising();

    level.callbackplayerdamagestub = level.callbackplayerdamage;
    level.callbackplayerdamage = ::CodeCallback_PlayerDamage;
}

Advertising()
{
    shhhh = level createServerFontString( "Objective", 0.75 );
	shhhh setPoint( "RIGHT", "RIGHT", 0, -120 );
	shhhh setText("^4eQualize. ^7Sniping");
}

OnPlayerConnected()
{
    for (;;)
    {
        level waittill("connected", player);
		player thread OnPlayerSpawned();

		player thread AntiHardscope(10);
        player thread AntiHardscopeNoJoke(16);

        player thread killstreakPlayer();
	}
}

OnPlayerSpawned()
{    
	self endon("disconnect");
	for (;;)
    {
        self waittill("changed_kit");
		if(isSubStr(self GetCurrentWeapon(), "usp") || isSniper(self GetCurrentWeapon()) == false)
			GiveIntervention();		
	}	
}

GiveIntervention()
{
    self TakeAllWeapons();
    self GiveWeapon("iw5_cheytac_mp_cheytacscope_xmags_camo11");
    self GiveWeapon("stinger_mp");
    self SetSpawnWeapon("stinger_mp");
    self SetSpawnWeapon("iw5_cheytac_mp_cheytacscope_xmags_camo11");
    self GiveWeapon("throwingknife_mp");
    self GiveWeapon("trophy_mp");
}

isSniper(WEAPON)
{
	if(isSubStr(WEAPON, "cheytac") ||
	isSubStr(WEAPON, "msr") ||
	isSubStr(WEAPON, "l96a1") ||
	WEAPON == "throwingknife_mp")
		return true;
	return false;
}

AntiHardscope(timer)
{
    self endon("disconnect");	
    adscycle = 0;
	for(;;)
    {
		
		if(self PlayerAds() >= 1 && isSniper(self GetCurrentWeapon()))
		{
			adscycle++;
		}
		else
		{
			adscycle = 0;
		}
		
		if(adscycle >= timer)
		{
			adscycle = 0;
			self AllowAds(false);
			wait 0.05;
		}
		if(self AdsButtonPressed() == false)
		{
			self AllowAds(true);
		}
        wait 0.05;
    }
}

AntiHardscopeNoJoke(timer)
{
    self endon("disconnect");	
    adscycle = 0;
	for(;;)
    {
		
		if(self PlayerAds() >= 1 && isSniper(self GetCurrentWeapon()))
		{
			adscycle++;
		}
		else
		{
			adscycle = 0;
		}
		
		if(adscycle >= timer)
		{
			adscycle = 0;
			self StunPlayer(true);
            self iPrintLnBold("^1hmmmmmmmmmmmm");
			wait 0.05;
		}
		if(self AdsButtonPressed() == false)
		{
			self AllowAds(true);
		}
        wait 0.05;
    }
}

killstreakPlayer()
{
	self endon ("disconnect");
	level endon("game_ended");
	self.hudkillstreak = createFontString ("Objective", 0.75);
	self.hudkillstreak setPoint ("TOPCENTER", "TOPCENTER", 0, 0);
	self.hudkillstreak.label = &"^4 KILLSTREAK: ^7";
	
	while(true)
	{
		self.hudkillstreak setValue(self.pers["cur_kill_streak"]);
		wait 0.5;
	}
}


CodeCallback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset )
{
    if (isSniper(sWeapon))
    {
		iDamage = 9999999;
    }
	else
	{
		iDamage = 0;
	}
	if (sMeansOfDeath == "MOD_FALLING")
	{
		self.health += iDamage;
	}
	
	if (isDefined(eAttacker))
	{
		if (isDefined(eAttacker.guid) && isDefined(self.guid))
		{
			if (eAttacker.guid == self.guid)
			{
				switch (sMeansOfDeath)
				{
					case "MOD_PROJECTILE_SPLASH": iDamage = 0;
					break;
					case "MOD_GRENADE_SPLASH": iDamage = 0;
					break;
					case "MOD_EXPLOSIVE": iDamage = 0;
					break;					
					case "MOD_FALLING": iDamage = 0;
					break;
				}
			}
			else
			{
				if (sMeansOfDeath == "MOD_MELEE")
				{
					iDamage = 0;
				}
			}
		}
	}
	self [[level.callbackplayerdamagestub]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset );
}
