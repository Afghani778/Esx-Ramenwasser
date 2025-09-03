ESX = exports["es_extended"]:getSharedObject()
local laatstGewerkt = {}

RegisterServerEvent("ramenwasser:setJob")
AddEventHandler("ramenwasser:setJob", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.setJob(Config.JobName, 0)
        TriggerClientEvent("esx:showNotification", source, Locales['nl']['job_taken'])
        print(("[LOG] %s (%s) nam de job Ramenwasser aan."):format(xPlayer.getName(), xPlayer.identifier))
    end
end)


RegisterServerEvent("ramenwasser:spawnBusje")
AddEventHandler("ramenwasser:spawnBusje", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or xPlayer.getJob().name ~= Config.JobName then
        print(("[ANTICHEAT] %s probeerde busje zonder job"):format(xPlayer and xPlayer.identifier or "unknown"))
        return
    end
    TriggerClientEvent("esx:spawnVehicle", source, Config.VoertuigModel, Config.SpawnPoint)
    print(("[LOG] %s (%s) kreeg busje."):format(xPlayer.getName(), xPlayer.identifier))
end)


RegisterServerEvent("ramenwasser:beloning")
AddEventHandler("ramenwasser:beloning", function(loc)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer or xPlayer.getJob().name ~= Config.JobName then return end
    local tijd = os.time()

    if laatstGewerkt[xPlayer.identifier] and tijd - laatstGewerkt[xPlayer.identifier] < Config.Cooldown then
        print(("[ANTICHEAT] %s probeerde te snel beloning te krijgen"):format(xPlayer.identifier))
        return
    end

    local bedrag = math.random(Config.MinBeloning, Config.MaxBeloning)
    xPlayer.addMoney(bedrag)
    TriggerClientEvent("esx:showNotification", src, "Je hebt ~g~€"..bedrag.."~s~ verdiend met ramen wassen.")
    laatstGewerkt[xPlayer.identifier] = tijd
    print(("[LOG] %s (%s) verdiende €%s bij een raam."):format(xPlayer.getName(), xPlayer.identifier, bedrag))
end)


CreateThread(function()
    while true do
        Wait(Config.SalarisInterval)
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer and xPlayer.getJob().name == Config.JobName then
                xPlayer.addAccountMoney('bank', Config.SalarisBedrag)
                TriggerClientEvent("esx:showNotification", xPlayer.source, string.format(Locales['nl']['salary_received'], Config.SalarisBedrag))
                print(("[LOG] %s (%s) kreeg salaris van €%s."):format(xPlayer.getName(), xPlayer.identifier, Config.SalarisBedrag))
            end
        end
    end
end)
