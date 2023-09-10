hook.Add("Initialize", "PriselHitman:Initialize", function()
	Prisel.Hitman.LoadConfigFile()
end)

hook.Add("PlayerDeath", "PriselHitman:PlayerDeath", function(victim, inf, attack)

	if not victim:IsValid() then return end
	if attack == victim then return end

	if IsValid(attack) then

		if attack:IsHitmanMode() and victim:IsValid() and Prisel.Hitman.Contracts[victim:SteamID64()] then

			local contrat = Prisel.Hitman.Contracts[victim:SteamID64()]

			-- if attack == contrat.Caller then
				-- return
			-- end


			if not tonumber(contrat.Price) then return end
			attack:addMoney(contrat.Price)
			DarkRP.notify(attack, 0, 4, "Vous avez gagné " .. DarkRP.formatMoney(contrat.Price).." pour avoir tué " .. victim:Nick() .. " !")
			DarkRP.notify(contrat.Caller, 0, 4, "Votre contrat sur " .. victim:Nick() .. " a été rempli !")
			hook.Run("Prisel.Hitman.ContractCompleted", contrat.Caller, attack, victim, contrat.Price)
			victim:RemoveContract()

		end

	end

	if victim:IsHitmanMode() then
		victim:RequestHitman()
		victim:RemoveContract()
	end

end)

hook.Add("PlayerDisconnected", "PriselHitman:PlayerDisconnected", function(pPly)
	pPly:RemoveContract()
end)

hook.Add("PlayerChangedTeam", "PriselHitman:PlayerChangedTeam", function(pPly, oldTeam, newTeam)
	print(pPly, oldTeam, newTeam)
end)