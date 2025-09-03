Config = {}

Config.JobName = "ramenwasser"

-- UWV locatie
Config.UWVLocation = vector3(-266.5, -963.6, 31.2)

-- Kledingkamer locatie
Config.Kledingkamer = vector3(-1193.2, -894.3, 13.9)

-- NPC busje
Config.VoertuigNPC = vector3(-1189.6, -888.3, 13.9)
Config.VoertuigModel = "pony"
Config.SpawnPoint = vector4(-1196.3, -891.6, 13.5, 35.0)

-- Ramen locaties
Config.RamenLocaties = {
    vector3(-706.12, -913.55, 19.22),
    vector3(-710.98, -905.33, 19.22),
    vector3(-699.74, -917.66, 19.22),
    vector3(215.34, -921.65, 30.69),
    vector3(150.66, -1037.12, 29.37),
    vector3(-75.12, -819.44, 326.17)
}

-- Beloning per raam
Config.MinBeloning = 12
Config.MaxBeloning = 75

-- Anti-cheat cooldown (sec)
Config.Cooldown = 15

-- Salaris
Config.SalarisInterval = 15 * 60 * 1000 -- 15 minuten
Config.SalarisBedrag = 275

-- Outfit
Config.Outfit = {
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1'] = 65,   ['torso_2'] = 0,
        ['pants_1'] = 38,   ['pants_2'] = 2,
        ['shoes_1'] = 25,   ['shoes_2'] = 0,
        ['helmet_1'] = 8,   ['helmet_2'] = 0,
    },
    female = {
        ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
        ['torso_1'] = 14,   ['torso_2'] = 0,
        ['pants_1'] = 30,   ['pants_2'] = 2,
        ['shoes_1'] = 6,    ['shoes_2'] = 0,
        ['helmet_1'] = 57,  ['helmet_2'] = 0,
    }
}
