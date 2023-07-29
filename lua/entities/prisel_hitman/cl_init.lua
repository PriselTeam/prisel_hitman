include("shared.lua")

local VectorCached = Vector(0, 0, 77)

function ENT:Initialize()
	self.VectorCached = VectorCached
end

function ENT:Draw()
	self:DrawModel()

	local localPlayer = LocalPlayer()
	local dist = localPlayer:GetPos():DistToSqr(self:GetPos())
	local floatAnim = math.sin(CurTime() * 5) * 1

	if dist < 200^2 then
		cam.Start3D2D(self:GetPos() + Vector(self.VectorCached.x, self.VectorCached.y, self.VectorCached.z + floatAnim), Angle(0, localPlayer:EyeAngles().y - 90, 90), 0.1)
			draw.SimpleTextOutlined(Prisel.Hitman.GetConfig("Name"), DarkRP.Library.Font(12), 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		cam.End3D2D()
	end
end
