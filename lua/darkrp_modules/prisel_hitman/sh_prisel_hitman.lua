TEAM_HITMAN = DarkRP.createJob( "Tueur à gages", {
    color = Color( 238, 69, 69),
    category = "Metiers illégaux",
    model = {
        "models/player/group01/male_01.mdl",
        "models/player/group01/male_02.mdl",
        "models/player/group01/male_03.mdl"
    },
    description = [[Le tueur à gages est un tueur professionnel qui est payé pour tuer des gens.]],
    weapons = { "prisel_jumelles" },
    command = "hitman_prisel",
    max = 2,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
} )