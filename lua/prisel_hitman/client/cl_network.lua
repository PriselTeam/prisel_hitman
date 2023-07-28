net.Receive("Prisel.Hitman.SendConfig", function()
  local cnf = net.ReadTable()
  Prisel.Hitman.Config = cnf
end)

net.Receive("Prisel.Hitman.OpenMenu", function()
  Prisel.Hitman.OpenContracts()
end)