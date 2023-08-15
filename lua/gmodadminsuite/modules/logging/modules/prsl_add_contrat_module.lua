local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Prisel - Hitman"
MODULE.Name = "Add Contrat"
MODULE.Colour = Color(255,0,0)


MODULE:Setup(function()

	MODULE:Hook("Prisel.Hitman.PlayerAddContract", "p:AddContratHooked", function(pPlayer, tTable)

        local sReason = tTable.Reason
        local iPrice = tTable.Price

		MODULE:Log("{1} à posé un contrat sur {2} pour \"{3}\" pour {4}.", GAS.Logging:FormatPlayer(tTable.Caller), GAS.Logging:FormatPlayer(pPlayer), GAS.Logging:Highlight(sReason), GAS.Logging:FormatMoney(iPrice))
	
    end)

end)

GAS.Logging:AddModule(MODULE)