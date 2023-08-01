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
    if Prisel.Hitman.CanModifConfig[ply:GetUserGroup()] then
        local config = net.ReadTable()
        if config then
            Prisel.Hitman.Config = config
            Prisel.Hitman.SaveConfigFile()
        end
    end
end
net.Receive("Prisel.Hitman.SendConfig", handleSendConfig)

local function handleRequestConfig(len, ply)
    ply:SendConfig()
    ply:SendContract()
end
net.Receive("Prisel.Hitman.RequestConfig", handleRequestConfig)

local function handleHitmanNetworking(len, ply)
    if not ply:CanInteractNPC() then return end

    local action = net.ReadUInt(4)
    if action == 1 then
        ply:RequestHitman()
    elseif action == 2 then
        local target = net.ReadEntity()
        if not IsValid(target) or not target:IsPlayer() or target:HasContract() then
            return
        end

        local reason = net.ReadString()
        if not reason or not DarkRP.Library.IsValidReason(reason) then return end

        local price = net.ReadUInt(20)
        if not price or not isnumber(price) or price < 0 or price > 1000000 then return end

        if not ply:canAfford(price) then return end

        ply:addMoney(-price)
        target:AddContract(reason, price, ply)
        DarkRP.notify(ply, 0, 4, ("Votre prime sur %s à bien été envoyé."):format(target:Nick()))
    end
end

net.Receive("Prisel.Hitman.HitmanNetworking", handleHitmanNetworking)
