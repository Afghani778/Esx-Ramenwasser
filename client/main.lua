ESX = exports["es_extended"]:getSharedObject()
local bezig, laatst = false, 0
local npc

-- Blips
CreateThread(function()
    local uwvBlip = AddBlipForCoord(Config.UWVLocation)
    SetBlipSprite(uwvBlip, 351)
    SetBlipColour(uwvBlip, 3)
    SetBlipScale(uwvBlip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("UWV - Jobs")
    EndTextCommandSetBlipName(uwvBlip)

    local kledingBlip = AddBlipForCoord(Config.Kledingkamer)
    SetBlipSprite(kledingBlip, 1)
    SetBlipColour(kledingBlip, 38)
    SetBlipScale(kledingBlip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Ramenwasser Kledingkamer")
    EndTextCommandSetBlipName(kledingBlip)
end)

-- UWV job selectie
CreateThread(function()
    while true do
        Wait(500)
        if #(GetEntityCoords(PlayerPedId()) - Config.UWVLocation) < 2.0 then
            ESX.ShowHelpNotification(Locales['nl']['job_taken'])
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent("ramenwasser:setJob")
            end
        end
    end
end)

-- Kledingkamer
CreateThread(function()
    while true do
        Wait(500)
        if #(GetEntityCoords(PlayerPedId()) - Config.Kledingkamer) < 2.0 then
            ESX.ShowHelpNotification(Locales['nl']['uniform'])
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:loadClothes', skin, Config.Outfit.male)
                    else
                        TriggerEvent('skinchanger:loadClothes', skin, Config.Outfit.female)
                    end
                end)
            end
        end
    end
end)

-- NPC Busje
CreateThread(function()
    local hash = GetHashKey("s_m_m_dockwork_01")
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end
    npc = CreatePed(4, hash, Config.VoertuigNPC, 180.0, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    while true do
        Wait(500)
        if #(GetEntityCoords(PlayerPedId()) - Config.VoertuigNPC) < 2.0 then
            ESX.ShowHelpNotification(Locales['nl']['busje'])
            if IsControlJustReleased(0, 38) then
                TriggerServerEvent("ramenwasser:spawnBusje")
            end
        end
    end
end)

-- Ramen wassen met kabel
function StartRamenWassen(loc)
    if bezig then return end
    bezig = true
    local ped = PlayerPedId()
    local start = GetEntityCoords(ped)
    local hoogte = loc + vector3(0.0, 0.0, 6.0)

    ESX.ShowNotification(Locales['nl']['up_cable'])
    for i = 1, 60 do
        local p = i / 60.0
        local x = start.x + (hoogte.x - start.x) * p
        local y = start.y + (hoogte.y - start.y) * p
        local z = start.z + (hoogte.z - start.z) * p
        SetEntityCoords(ped, x, y, z)
        Wait(100)
    end

    RequestAnimDict("amb@world_human_maid_clean@")
    while not HasAnimDictLoaded("amb@world_human_maid_clean@") do Wait(10) end
    TaskPlayAnim(ped, "amb@world_human_maid_clean@", "base", 3.0, -1, -1, 49, 0, false, false, false)
    exports['progressBars']:startUI(6000, Locales['nl']['progress_clean'])
    Wait(6000)
    ClearPedTasks(ped)

    for i = 1, 60 do
        local p = i / 60.0
        local x = hoogte.x + (start.x - hoogte.x) * p
        local y = hoogte.y + (start.y - hoogte.y) * p
        local z = hoogte.z + (start.z - hoogte.z) * p
        SetEntityCoords(ped, x, y, z)
        Wait(100)
    end

    TriggerServerEvent("ramenwasser:beloning", loc)
    bezig = false
end

-- Markers ramen
CreateThread(function()
    while true do
        local sleep = 1500
        for _,loc in pairs(Config.RamenLocaties) do
            local dist = #(GetEntityCoords(PlayerPedId()) - loc)
            if dist < 10.0 then
                sleep = 0
                DrawMarker(2, loc.x, loc.y, loc.z+1.0, 0,0,0,0,0,0,0.3,0.3,0.3,0,150,255,200,false,true,2,true)
                if dist < 1.5 and not bezig then
                    ESX.ShowHelpNotification(Locales['nl']['was_raam'])
                    if IsControlJustReleased(0, 38) then
                        StartRamenWassen(loc)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
