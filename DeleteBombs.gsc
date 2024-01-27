init()
{
    print("deletebombs loaded");
    deleteEntity("sd_bomb_pickup_trig");
    deleteEntity("sd_bomb");
    replacefunc(maps\mp\gametypes\sd::oncantuse, ::idiot);
    SetDvar("waypointiconheight", 1);
    SetDvar("waypointiconwidth", 1);
}


idiot( player )
{
    player iPrintLnBold("stupid cunt go play");
}

deleteEntity(targetName)
{
    entityToDelete = getEnt(targetName, "targetname");
    if (isDefined(entityToDelete))
    {
        entityToDelete delete();
        print("Deleted " + targetName);
    }
    else
    {
        print("Error: " + targetName + " not found.");
    }
}