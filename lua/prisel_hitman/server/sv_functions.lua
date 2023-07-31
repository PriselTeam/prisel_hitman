function Prisel.Hitman.SaveConfigFile()
  local config = Prisel.Hitman.Config
  local json = util.TableToJSON(config, true)

  if not file.IsDir("prisel_hitman", "DATA") then
      file.CreateDir("prisel_hitman")
  end

  file.Write("prisel_hitman/prisel_hitman_config.json", json)

  if not file.Exists("prisel_hitman/prisel_hitman_config.json", "DATA") then
      print("Erreur lors de la sauvegarde de la configuration : le fichier n'existe pas.")
  else
      print("Configuration sauvegardée avec succès.")
      Prisel.Hitman.SendConfigToPlayers()
  end
end

function Prisel.Hitman.LoadConfigFile()
  if not file.IsDir("prisel_hitman", "DATA") then
      file.CreateDir("prisel_hitman")
  end

  local json = file.Read("prisel_hitman/prisel_hitman_config.json", "DATA")

  if json then
      local config = util.JSONToTable(json)

      if config then
          Prisel.Hitman.Config = config
          print("Configuration chargée avec succès.")
      end
  else
      print("Aucun fichier de configuration trouvé. Utilisation de la configuration par défaut.")
  end
end

function Prisel.Hitman.SendConfigToPlayers()
  local config = Prisel.Hitman.Config
  net.Start("Prisel.Hitman.SendConfig")
  net.WriteTable(config)
  net.Broadcast()
end

function Prisel.Hitman.SendContrats()
  net.Start("Prisel.Hitman.HitmanNetworking")
  net.WriteUInt(1, 4)
  net.WriteTable(Prisel.Hitman.Contracts)
  net.Broadcast()
end

function Prisel.Hitman.UpdateContrat(newCtr)
  net.Start("Prisel.Hitman.HitmanNetworking")
  net.WriteUInt(2, 4)
  net.WriteTable(newCtr)
  net.Broadcast()
end

function Prisel.Hitman.RemoveContrat(steamid)
  print("Remove contract", steamid)
  net.Start("Prisel.Hitman.HitmanNetworking")
  net.WriteUInt(3, 4)
  net.WriteString(steamid)
  net.Broadcast()
end

local PLAYER = FindMetaTable("Player")

function PLAYER:SendContract()
  net.Start("Prisel.Hitman.HitmanNetworking")
  net.WriteUInt(1, 4)
  net.WriteTable(Prisel.Hitman.Contracts or {})
  net.Send(self)
end

function PLAYER:SendConfig()
  local config = Prisel.Hitman.Config
  net.Start("Prisel.Hitman.SendConfig")
  net.WriteTable(config)
  net.Send(self)
end

function PLAYER:OpenContractMenu()
  net.Start("Prisel.Hitman.OpenMenu")
  net.Send(self)
end

function PLAYER:CanInteractNPC()
  local hitman = ents.FindInSphere(self:GetPos(), 100)

  for k, v in pairs(hitman) do
      if v:GetClass() == "prisel_hitman" then
          if v:GetPos():Distance(self:GetPos()) < 100 then
              return true
          end                
      end
  end

  return false
end

function PLAYER:AddContract(reason, price)
  if not IsValid(self) then
    return
  end

  if self:HasContract() then
    return
  end

  local contrat = {
    Reason = reason,
    Price = price,
    Target = self,
    Timestamp = os.time(),
  }

  Prisel.Hitman.Contracts[self:SteamID64()] = contrat
  Prisel.Hitman.UpdateContrat(contrat)
end

function PLAYER:RemoveContract()
  if not IsValid(self) then
    return
  end

  Prisel.Hitman.Contracts[self:SteamID64()] = nil
  print("Remove contract", self:SteamID64())
  Prisel.Hitman.RemoveContrat(self:SteamID64())
end
