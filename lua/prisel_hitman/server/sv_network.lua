local networkStrings = {
    "Prisel.Hitman.SendConfig",
    "Prisel.Hitman.RequestConfig",
    "Prisel.Hitman.OpenMenu",
    "Prisel.Hitman.HitmanNetworking"
}

for _, netString in ipairs(networkStrings) do
    util.AddNetworkString(netString)
end

local function handleSendConfig(len, ply)
    if not Prisel.Hitman.CanModifConfig[ply:GetUserGroup()] then return end
    local config = net.ReadTable()
    if not config then return end
    Prisel.Hitman.Config = config
    Prisel.Hitman.SaveConfigFile()
end
net.Receive("Prisel.Hitman.SendConfig", handleSendConfig)

local function handleRequestConfig(len, ply)
    ply:SendConfig()
end
net.Receive("Prisel.Hitman.RequestConfig", handleRequestConfig)

local function handleHitmanNetworking(len, ply)
    local action = net.ReadUInt(4)
    if action == 1 and ply:CanInteractNPC() then
        ply:RequestHitman()
    elseif action == 2 and ply:CanInteractNPC() then
        local target = net.ReadEntity()
        if not IsValid(target) then return end
        local reason = net.ReadString()
        if not reason then return end
        if not DarkRP.Library.IsValidReason(reason) then return end
        local price = net.ReadUInt(20)
        if not price then return end
        if not isnumber(price) then return end
        if price < 0 then return end
        if price > 1000000 then return end

        print("Hitman request", ply, target, reason, price)
    end
end
net.Receive("Prisel.Hitman.HitmanNetworking", handleHitmanNetworking)
