net.Receive("Prisel.Hitman.SendConfig", function()
  local cnf = net.ReadTable()
  Prisel.Hitman.Config = cnf
end)

net.Receive("Prisel.Hitman.OpenMenu", function()
  Prisel.Hitman.OpenContracts()
end)

net.Receive("Prisel.Hitman.HitmanNetworking", function()
  local action = net.ReadUInt(4)

  if action == 1 then
    local contrat = net.ReadTable()
    Prisel.Hitman.Contracts = contrat
  elseif action == 2 then
    local contrat = net.ReadTable()
    if not IsValid(contrat.Target) then return end
    local id64 = contrat.Target

    Prisel.Hitman.Contracts = Prisel.Hitman.Contracts or {}
    Prisel.Hitman.Contracts[id64] = contrat
  elseif action == 3 then
    local id64 = net.ReadString()
    Prisel.Hitman.Contracts[id64] = nil
  end
end)