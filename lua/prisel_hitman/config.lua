Prisel = Prisel or {}
Prisel.Hitman = Prisel.Hitman or {}
Prisel.Hitman.Contracts = Prisel.Hitman.Contracts or {}
Prisel.Hitman.CanModifConfig = {
    ["superadmin"] = true,
}

Prisel.Hitman.Config = Prisel.Hitman.Config or {}

Prisel.Hitman.Config.Model = "models/Humans/Group01/Female_06.mdl"
Prisel.Hitman.Config.CommandConfig = "!cfghitman"

Prisel.Hitman.Config.BlacklistedJob = {
    ["Policier"] = true,
}

Prisel.Hitman.Config.Name = "Tueur à gages"

Prisel.Hitman.Config.EnableFakeNPC = true

Prisel.Hitman.Config.Reward = {Min = 1000, Max = 25000}

Prisel.Hitman.Config.PossibleSpawn = {}

Prisel.Hitman.Config.FakeNPCModel = {
    ["Women"] = {
        "models/mossman.mdl",
        "models/alyx.mdl",
        "models/Humans/Group01/Female_01.mdl",
        "models/Humans/Group01/Female_02.mdl",
        "models/Humans/Group01/Female_03.mdl",
        "models/Humans/Group01/Female_04.mdl",
        "models/Humans/Group01/Female_05.mdl",
        "models/Humans/Group01/Female_06.mdl",
        "models/Humans/Group01/Female_07.mdl",
        "models/Humans/Group01/Female_08.mdl",
        "models/Humans/Group01/Female_09.mdl",
    },

    ["Men"] = {
        "models/Barney.mdl",
        "models/breen.mdl",
        "models/Eli.mdl",
        "models/gman_high.mdl",
        "models/Kleiner.mdl",
        "models/monk.mdl",
        "models/odessa.mdl"
    }
}

Prisel.Hitman.Config.FakeName = {
    ["Women"] = {
        "Marie Chaton",
        "Juliette Lapin",
        "Amandine Croissant",
        "Camille Crème",
        "Colette Citron",
        "Élodie Escargot",
        "Henriette Escalope",
        "Violette Chocolat",
        "Léa Lavande",
        "Clémentine Citron",
        "Isabelle Prune",
        "Sylvie Sorbet",
        "Émilie Myrtille",
        "Alice Abricot",
        "Adèle Mirabelle",
        "Madeleine Myrtille",
        "Rosalie Raisin",
        "Salomé Salsifis",
        "Valentine Vanille",
        "Roxane Radis",
        "Clémence Cerise",
        "Élise Noisette",
        "Vivienne Verveine",
        "Olympe Orange",
    },

    ["Men"] = {
        "Jean Bon",
        "Pierre Roulade",
        "Arthur Tournesol",
        "Maxime Fromage",
        "Lucien Baguette",
        "Gustave Escargot",
        "Théo Croissant",
        "Gaspard Fromage",
        "Henri Poireau",
        "Jules Poireau",
        "Léo Raisin",
        "Alexandre Avocat",
        "Étienne Courgette",
        "Hugo Champignon",
        "Antoine Artichaut",
        "Matthieu Miel",
        "Édouard Cassis",
        "Baptiste Brioche",
        "César Citron",
        "Hector Haricot",
        "Félix Figue",
        "Léonard Laurier",
        "Quentin Quetsche",
        "Romain Rhubarbe",
        "Victor Vanille",
        "Zacharie Zeste",
        "Yann Yuzu",
    },
}
