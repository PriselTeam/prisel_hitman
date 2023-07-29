hook.Add("OnPlayerChat", "Prisel:Hitman:OnPlayerChat", function(ply, txt)
	if ply == LocalPlayer() and string.lower(txt) == Prisel.Hitman.Config.CommandConfig then
		if Prisel.Hitman.CanModifConfig[ply:GetUserGroup()] then
			Prisel.Hitman.ConfigMenu()
			return true
		end
	end
end)

hook.Add("PostGamemodeLoaded", "Prisel:Hitman:PostGamemodeLoaded", function()
	if not IsValid(LocalPlayer()) then return end

	LocalPlayer():RequestConfig()
end)


hook.Add("HUDPaint", "Prisel.Hitman.ReceiveCONFIG", function()
    LocalPlayer():RequestConfig()
    hook.Remove("HUDPaint", "Prisel.Hitman.ReceiveCONFIG")
end)