function Prisel.Hitman.GetConfig(value)
  if not Prisel.Hitman.Config or not value or Prisel.Hitman.Config[value] == nil then
      print("Erreur : Clé de configuration invalide.")
      return ("%s n'est pas dans la configuration."):format(value)
  end

  return Prisel.Hitman.Config[value]
end


local PLAYER = FindMetaTable("Player")

function PLAYER:IsHitmanMode()
  return self:Team() == TEAM_HITMAN
end

function PLAYER:HasContract()
  if not IsValid(self) then
    return false
  end

  local hasContract = Prisel.Hitman.Contracts[self:SteamID64()] ~= nil
  return hasContract
end