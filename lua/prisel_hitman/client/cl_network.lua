net.Receive("Prisel.Hitman.SendConfig", function()
  local tConfig = net.ReadTable()
  Prisel.Hitman.Config = tConfig
end)

net.Receive("Prisel.Hitman.OpenMenu", function()
  Prisel.Hitman.OpenContracts()
end)

net.Receive("Prisel.Hitman.HitmanNetworking", function()
  local iAction = net.ReadUInt(4)
  if iAction == 1 then
    local contrat = net.ReadTable()
    Prisel.Hitman.Contracts = contrat
  elseif iAction == 2 then

    local pTarget = net.ReadEntity()
    local iPrice = net.ReadUInt(8)
    local sReason = net.ReadString()
    local iID64 = net.ReadString()

    if not IsValid(pTarget) then return end

    Prisel.Hitman.Contracts = Prisel.Hitman.Contracts or {}

    local contrat = {
      Target = pTarget,
      Price = iPrice,
      Reason = sReason
    }

    Prisel.Hitman.Contracts[iID64] = contrat

  elseif iAction == 3 then
    local iID64 = net.ReadString()
    Prisel.Hitman.Contracts[iID64] = nil
  end
end)