function Prisel.Hitman.GetConfig(value)
  if not Prisel.Hitman.Config or not value or Prisel.Hitman.Config[value] == nil then
      print("Erreur : Clé de configuration invalide.")
      return ("%s n'est pas dans la configuration."):format(value)
  end

  return Prisel.Hitman.Config[value]
end


local PLAYER = FindMetaTable("Player")

function PLAYER:IsHitman()
  return self:GetNWBool("PRSL:HitmanValue")
end

function PLAYER:RequestHitman()
  if CLIENT then
    net.Start("Prisel.Hitman.HitmanNetworking")
    net.WriteUInt(1, 4)
    net.SendToServer()
  elseif SERVER then
    self:SetNWBool("PRSL:HitmanValue", not self:IsHitman())
    if self:IsHitman() then
      DarkRP.notify(self, 0, 4, "Vous êtes maintenant un chasseur de prime.")
    else
      DarkRP.notify(self, 1, 4, "Vous avez arrêtez la traque.")
    end
  end
end