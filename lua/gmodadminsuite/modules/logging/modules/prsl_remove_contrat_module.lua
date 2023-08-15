local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Prisel - Hitman"
MODULE.Name = "Removed Contrat"
MODULE.Colour = Color(255,0,0)


MODULE:Setup(function()

	MODULE:Hook("Prisel.Hitman.PlayerRemovedContract", "p:RemovedContratHooked", function(pPlayer)


		MODULE:Log("Contrat sur {1} retiré.", GAS.Logging:FormatPlayer(pPlayer))
	
    end)

end)

GAS.Logging:AddModule(MODULE)