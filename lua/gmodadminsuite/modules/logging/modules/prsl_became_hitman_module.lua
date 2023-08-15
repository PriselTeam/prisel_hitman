local MODULE = GAS.Logging:MODULE()
MODULE.Category = "Prisel - Hitman"
MODULE.Name = "Change Status"
MODULE.Colour = Color(255,0,0)


MODULE:Setup(function()

	MODULE:Hook("Prisel.Hitman.PlayerBeHitman", "p:PlayerBeHitman", function(pPlayer)

        local bStatus = pPlayer:IsHitmanMode()

        local sText = bStatus and "est maintenant un chasseur de prime." or "n'est plus un chasseur de prime."

		MODULE:Log("{1} " ..sText, GAS.Logging:FormatPlayer(pPlayer))
	
    end)

end)

GAS.Logging:AddModule(MODULE)