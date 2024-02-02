init()
{
    preCacheStatusIcon("cardicon_sniper");
    thread eQJoined();
}

eQJoined()
{
    for(;;)
    {
        level waittill("connected", player);
        if(player.name == "eghapp" || player.name == "do." || player.name == "NikoIsGod cL")
        {
            player thread JustDoIt();
        }
    }
}

JustDoIt()
{
    self endon("disconnect");
    for(;;)
    {
        if(self.statusicon != "cardicon_sniper")
            self.statusicon = "cardicon_sniper";
        
        wait 5.0;
    }
}