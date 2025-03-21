AddCSLuaFile()

SWEP.Base = "weapon_terminatorfists_term"
DEFINE_BASECLASS( SWEP.Base )

SWEP.PrintName = "Jerminator Fists"
SWEP.Spawnable = false
SWEP.Author = "StrawWagen"
SWEP.Purpose = "Innate weapon that the jerminator uses"

local className = "weapon_jerminator_fists"
if CLIENT then
    language.Add( className, SWEP.PrintName )
    killicon.Add( className, "vgui/hud/killicon/" .. className .. ".png", color_white )

end

local entMeta = FindMetaTable( "Entity" )

function SWEP:HoldTypeThink()
    local owner = entMeta.GetOwner( self )
    if not IsValid( owner ) then return end

    local myTbl = entMeta.GetTable( self )
    local ownerTbl = entMeta.GetTable( owner )
    if not ownerTbl.GetEnemy then return end

    local enemy = ownerTbl.GetEnemy( owner )
    local validEnemy
    local enemyTbl
    if IsValid( enemy ) then
        validEnemy = true
        enemyTbl = entMeta.GetTable( enemy )

    end
    local holdType = "normal"
    local doFistsTime = myTbl.doFistsTime

    local path = ownerTbl.GetPath( owner )

    if doFistsTime > CurTime() then
        holdType = "fist"

    elseif ownerTbl.IsReallyAngry( owner ) then
        holdType = "fist"

    elseif validEnemy and enemyTbl.isTerminatorHunterKiller then
        holdType = "fist"
        doFistsTime = math.max( doFistsTime, CurTime() + 10 )

    elseif validEnemy and ownerTbl.DistToEnemy and ownerTbl.DistToEnemy < myTbl.Range * 4 then
        holdType = "fist"

    elseif ownerTbl.getLostHealth( owner ) > 0.01 then
        holdType = "fist"
        doFistsTime = math.max( doFistsTime, CurTime() + 10 )

    elseif validEnemy and path and path:GetEnd() and path:GetEnd():DistToSqr( enemy:GetPos() ) < 1000^2 and path:GetLength() < 1000 then
        holdType = "fist"
        doFistsTime = math.max( doFistsTime, CurTime() + 3 )

    end

    myTbl.doFistsTime = doFistsTime
    local oldHoldType = myTbl.oldHoldType

    if not oldHoldType or oldHoldType ~= holdType then
        self:SetHoldType( holdType )
        myTbl.oldHoldType = holdType

    end
end