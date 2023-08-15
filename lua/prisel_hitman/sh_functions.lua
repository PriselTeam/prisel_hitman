function Prisel.Hitman.GetConfig(value)
  if not Prisel.Hitman.Config or not value or Prisel.Hitman.Config[value] == nil then
      print("Erreur : Clé de configuration invalide.")
      return ("%s n'est pas dans la configuration."):format(value)
  end

  return Prisel.Hitman.Config[value]
end


local PLAYER = FindMetaTable("Player")

function PLAYER:IsHitmanMode()
  return self:GetNWBool("PRSL:HitmanValue")
end

function PLAYER:RequestHitman()
  if CLIENT then
    net.Start("Prisel.Hitman.HitmanNetworking")
    net.WriteUInt(1, 4)
    net.SendToServer()
  elseif SERVER then
    self:SetNWBool("PRSL:HitmanValue", not self:IsHitmanMode())
    if self:IsHitmanMode() then
      DarkRP.notify(self, 0, 4, "Vous êtes maintenant un chasseur de prime.")
      DarkRP.notify(self, 0, 4, "Appuyez sur F2 pour voir les contrats disponibles.")
    else
      DarkRP.notify(self, 1, 4, "Vous avez arrêtez la traque.")
    end

    hook.Run("Prisel.Hitman.PlayerBeHitman", self)
  end
end

function PLAYER:HasContract()
  if not IsValid(self) then
    return false
  end

  local hasContract = Prisel.Hitman.Contracts[self:SteamID64()] ~= nil
  return hasContract
end