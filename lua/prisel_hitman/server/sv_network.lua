util.AddNetworkString("Prisel.Hitman.SendConfig")
util.AddNetworkString("Prisel.Hitman.RequestConfig")
util.AddNetworkString("Prisel.Hitman.OpenMenu")
util.AddNetworkString("Prisel.Hitman.HitmanNetworking")

net.Receive("Prisel.Hitman.SendConfig", function(len, ply)
    if not Prisel.Hitman.CanModifConfig[ply:GetUserGroup()] then return end

    local config = net.ReadTable()

    if not config then return end

    Prisel.Hitman.Config = config

    Prisel.Hitman.SaveConfigFile()
end)

net.Receive("Prisel.Hitman.RequestConfig", function(len, ply)
    ply:SendConfig()
end)

net.Receive("Prisel.Hitman.HitmanNetworking", function(_, ply)
    local action = net.ReadUInt(4)

    if action == 1 then
        if not ply:CanInteractNPC() then return end
        ply:RequestHitman()
    end
end)