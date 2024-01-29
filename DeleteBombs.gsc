//by swifty

main()
{
    printLn("sd_nobombs::main called.");
    setDvarIfUninitialized( "sv_remove_bombsites", 0 );
    if (getDvarInt("sv_remove_bombsites") && getDvar("g_gametype") == "sd") 
    {
        replacefunc(maps\mp\gametypes\_gameobjects::main, ::_gameobjects_main_custom);
    }
}
_gameobjects_main_custom(allowed)
{
	entitytypes = getentarray();
    for(i = 0; i < entitytypes.size; i++)
    {
        if(isdefined(entitytypes[i].script_gameobjectname))
        {
            if (entitytypes[i].script_gameobjectname == "airdrop_pallet") continue;//carepackage collision dont wanna delete

            entitytypes[i] delete();
        }
    }
}
