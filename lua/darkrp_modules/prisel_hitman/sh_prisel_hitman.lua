TEAM_HITMAN = DarkRP.createJob("*VIP* Tueur à gages", {
    color = Color(39, 174, 96),
    model = defaultCitizensModels,
    description = [[Vous exécutez des contrats contre rémunération, assurez vous d'avoir une raison valable de votre client pour faire votre travail.]],
    weapons = {"grappin","tfa_nmrih_mkiii"},
    command = "mob",
    max = 2,
    salary = 1000,
    category = "Métiers illégaux",
    customCheck = function(ply) return CLIENT or
        (ply:PIsVIP() or ply:PIsStaff())
    end,
    CustomCheckFailMsg = "Ce métier est VIP !",
    
})