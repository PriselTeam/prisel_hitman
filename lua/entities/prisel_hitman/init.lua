AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(Prisel.Hitman.GetConfig("Model"))
	self:SetBodygroup(1,1)
	self:SetSolid(SOLID_BBOX)

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()

	self:SetNPCState(NPC_STATE_SCRIPT)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetMoveType(MOVETYPE_NONE)

	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
end

function ENT:Think()
	if Prisel.Hitman.GetConfig("Model") ~= self:GetModel() then
		self:SetModel(Prisel.Hitman.GetConfig("Model"))
	end
end

function ENT:OnTakeDamage()
	return false
end

local cooldownPlayers = {}

function ENT:Use( act, pCaller )
	if not IsValid( pCaller ) or not pCaller:IsPlayer() then
		return
	end

	if cooldownPlayers[pCaller:SteamID64()] and cooldownPlayers[pCaller:SteamID64()] > CurTime() then
		DarkRP.notify(pCaller, 1, 4, "Veuillez patienter avant de lui reparler.")
		return
	end

	cooldownPlayers[pCaller:SteamID64()] = CurTime() + 1

	if Prisel.Hitman.GetConfig("BlacklistedJob")[team.GetName(pCaller:Team())] then
		DarkRP.notify(pCaller, 1, 4, "Vous ne pouvez pas prendre ni mettre de contrat en étant "..team.GetName(pCaller:Team())..".")
		return
	end

	if pCaller:isArrested() then
		DarkRP.notify(pCaller, 1, 4, "Vous ne pouvez pas prendre ni mettre de contrat en étant arrêté.")
		return
	end

	pCaller:OpenContractMenu()
end