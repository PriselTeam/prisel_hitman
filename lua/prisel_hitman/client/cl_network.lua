net.Receive("Prisel.Hitman.SendConfig", function()
  local tConfig = net.ReadTable()
  Prisel.Hitman.Config = tConfig
end)

net.Receive("Prisel.Hitman.OpenMenu", function()
  Prisel.Hitman.OpenContracts()
end)

net.Receive("Prisel.Hitman.HitmanNetworking", function()
  local iiAction = net.ReadUInt(4)
  if iAction == 1 then
    local contrat = net.ReadTable()
    Prisel.Hitman.Contracts = contrat
  elseif iAction == 2 then
    local contrat = net.ReadTable()
    if not IsValid(contrat.Target) then return end
    local iID64 = contrat.Target
    Prisel.Hitman.Contracts = Prisel.Hitman.Contracts or {}
    Prisel.Hitman.Contracts[iID64] = contrat
  elseif iAction == 3 then
    local iID64 = net.ReadString()
    Prisel.Hitman.Contracts[iID64] = nil
  end
end)