local doingDynamicContent = CreateConVar( "jerminator_dynamic_content", 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, "Dynamically request the jerma sounds whenever a bot is spawned?" )

if not SERVER then return end

if not doingDynamicContent:GetBool() then -- this will only work after a server restart with the new convar!
    resource.AddWorkshop( "3330585475" ) -- bot ( sounds )
    resource.AddWorkshop( "2691974423" ) -- playermodel

end