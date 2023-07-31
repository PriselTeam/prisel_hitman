include("shared.lua")

local vecAboveNPC = Vector(0, 0, 77)

function ENT:Initialize()
	self.vecAboveNPC = vecAboveNPC
end

function ENT:Draw()
	self:DrawModel()

	local pLocalPlayer = LocalPlayer()
	local fDist = pLocalPlayer:GetPos():DistToSqr(self:GetPos())
	local fAnim = math.sin(CurTime() * 5) * 1

	if fDist < 200^2 then
		cam.Start3D2D(self:GetPos() + Vector(self.vecAboveNPC.x, self.vecAboveNPC.y, self.vecAboveNPC.z + fAnim), Angle(0, pLocalPlayer:EyeAngles().y - 90, 90), 0.1)
			draw.SimpleTextOutlined(Prisel.Hitman.GetConfig("Name"), DarkRP.Library.Font(12), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		cam.End3D2D()
	end
end
