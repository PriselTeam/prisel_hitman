local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Prisel - Hitman"
MODULE.Name = "Completed Contrat"
MODULE.Colour = Color(255,0,0)


MODULE:Setup(function()

	MODULE:Hook("Prisel.Hitman.ContractCompleted", "p:ContractCompleted", function(pCaller, pAttack, pVictim, iPrice)

        MODULE:Log("{1} à complété un contrat sur {2} pour {3}.", GAS.Logging:FormatPlayer(pCaller), GAS.Logging:FormatPlayer(pVictim), GAS.Logging:FormatMoney(iPrice))
        
    end)

end)

GAS.Logging:AddModule(MODULE)