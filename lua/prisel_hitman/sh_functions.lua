function Prisel.Hitman.GetConfig(value)
  if not Prisel.Hitman.Config or not value or Prisel.Hitman.Config[value] == nil then
      print("Erreur : Clé de configuration invalide.")
      return nil
  end

  return Prisel.Hitman.Config[value]
end
