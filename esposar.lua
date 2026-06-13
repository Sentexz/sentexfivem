--[[
    Script de esposas para Susano (FiveM) - Enfoque en eventos de servidor
    Tecla [K] -> Intenta esposar al jugador más cercano
    Tecla [L] -> Liberarte
]]

local isCuffed = false
local originalSpeed = 1.0

-- ==================================================
-- 1. FUNCIÓN: OBTENER JUGADOR MÁS CERCANO
-- ==================================================
function GetClosestPlayer(radius)
    local players = GetGamePool('CPed')
    local closestDistance = radius
    local closestPed = nil
    local closestPlayer = nil
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, ped in ipairs(players) do
        if IsPedAPlayer(ped) and ped ~= playerPed then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(playerCoords - pedCoords)
            if distance < closestDistance then
                closestDistance = distance
                closestPed = ped
                closestPlayer = NetworkGetPlayerIndexFromPed(ped)
            end
        end
    end
    return closestPlayer, closestPed, closestDistance
end

-- ==================================================
-- 2. ATAQUE DE EVENTOS MASIVOS
-- ==================================================
function TriggerMassEvents(targetPlayer)
    if not targetPlayer then return end
    local targetServerId = GetPlayerServerId(targetPlayer)
    if not targetServerId then return end

    -- Eventos de policía comunes
    local events_to_trigger = {
        'esx_policejob:handcuff',
        'police:handcuff',
        'qb-police:handcuff',
        'handcuff',
        'cuff',
        'esx_policejob:requestarrest',
        'police:cuff',
        'police:server:cuff',
        'esx_handcuff:cuff',
        'cuffServer',
        'BsCuff:Cuff696999',
        'cuffGranted'
    }

    for _, event in ipairs(events_to_trigger) do
        -- Enviar evento dirigido al servidor
        TriggerServerEvent(event, targetServerId)
        TriggerServerEvent(event, GetPlayerServerId(PlayerId()))
        
        -- Enviar evento dirigido al objetivo
        TriggerServerEvent(event, targetPlayer)
        
        -- Para eventos que se manejan en cliente
        TriggerEvent(event, targetServerId)
        TriggerEvent(event, targetPlayer)
    end
    ShowNotification("~b~[SUSANO]~w~ Masiva descarga de eventos enviada.")
end

function TriggerMassCommands(targetPlayer)
    local targetServerId = GetPlayerServerId(targetPlayer)
    if not targetServerId then return end

    local commands_to_execute = {
        'cuff', 'handcuff', 'esposar', 'hc', 'arrest',
        'cuff ' .. targetServerId, 'handcuff ' .. targetServerId,
        'esposar ' .. targetServerId, 'hc ' .. targetServerId,
        'arrest ' .. targetServerId
    }
    
    for _, cmd in ipairs(commands_to_execute) do
        ExecuteCommand(cmd)
    end
    ShowNotification("~b~[SUSANO]~w~ Comandos ejecutados.")
end

-- ==================================================
-- 3. EFECTOS EN EL JUGADOR LOCAL (CUANDO TE ESPOSAN)
-- ==================================================
function ApplyLocalCuffs()
    if isCuffed then return end
    isCuffed = true
    
    RequestAnimDict('mp_arresting')
    while not HasAnimDictLoaded('mp_arresting') do
        Citizen.Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)
    
    originalSpeed = GetEntitySpeed(PlayerPedId())
    SetEntityMaxSpeed(PlayerPedId(), 0.8)
    
    Citizen.CreateThread(function()
        while isCuffed do
            Citizen.Wait(0)
            DisableControlAction(0, 21, true)  -- Saltar
            DisableControlAction(0, 24, true)  -- Atacar
            DisableControlAction(0, 25, true)  -- Apuntar
            DisableControlAction(0, 47, true)  -- Soltar arma
            DisableControlAction(0, 58, true)  -- Acelerar
            DisableControlAction(0, 59, true)  -- Acelerar (alternativo)
            DisableControlAction(0, 22, true)  -- Saltar (alternativo)
            DisableControlAction(0, 23, true)  -- Agacharse
            DisableControlAction(0, 75, true)  -- Entrar/salir vehículo
            DisableControlAction(0, 80, true)  -- Usar teléfono
            DisableControlAction(0, 140, true) -- Carrera
        end
    end)
end

function RemoveLocalCuffs()
    if not isCuffed then return end
    isCuffed = false
    ClearPedTasks(PlayerPedId())
    SetEntityMaxSpeed(PlayerPedId(), originalSpeed)
    SetPedMoveRateOverride(PlayerPedId(), 1.0)
end

-- ==================================================
-- 4. NOTIFICACIONES Y ESCUCHA DE EVENTOS
-- ==================================================
function ShowNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(0, 1)
end

-- Escuchar eventos para ser esposado
RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
    ApplyLocalCuffs()
    ShowNotification("~r~¡Te han esposado! Usa L para liberarte.")
end)

RegisterNetEvent('police:handcuff')
AddEventHandler('police:handcuff', function()
    ApplyLocalCuffs()
    ShowNotification("~r~¡Te han esposado! Usa L para liberarte.")
end)

RegisterNetEvent('qb-police:handcuff')
AddEventHandler('qb-police:handcuff', function()
    ApplyLocalCuffs()
    ShowNotification("~r~¡Te han esposado! Usa L para liberarte.")
end)

RegisterNetEvent('handcuff')
AddEventHandler('handcuff', function()
    ApplyLocalCuffs()
    ShowNotification("~r~¡Te han esposado! Usa L para liberarte.")
end)

RegisterNetEvent('cuff')
AddEventHandler('cuff', function()
    ApplyLocalCuffs()
    ShowNotification("~r~¡Te han esposado! Usa L para liberarte.")
end)

-- ==================================================
-- 5. BUCLE PRINCIPAL (DETECCIÓN DE TECLAS)
-- ==================================================
Citizen.CreateThread(function()
    ShowNotification("~g~[SUSANO]~w~ Script de explotación cargado. Usa [K] para esposar al más cercano.")
    while true do
        Citizen.Wait(0)
        
        -- Tecla K (código 311)
        if IsControlJustPressed(0, 311) then
            if not isCuffed then
                local closestPlayer, closestPed, dist = GetClosestPlayer(3.0)
                if closestPlayer then
                    local playerName = GetPlayerName(closestPlayer)
                    local serverId = GetPlayerServerId(closestPlayer)
                    ShowNotification("~b~Objetivo: " .. playerName .. " (ID:" .. serverId .. ") Dist: " .. string.format("%.1f", dist))
                    
                    -- Llamadas a todos los métodos
                    TriggerMassEvents(closestPlayer)
                    TriggerMassCommands(closestPlayer)
                    
                    ShowNotification("~g~[SUSANO]~w~ Intento de esposamiento completado.")
                else
                    ShowNotification("~r~[SUSANO]~w~ No hay jugadores cerca (3m)")
                end
            else
                ShowNotification("~r~[SUSANO]~w~ No puedes esposar mientras estás esposado")
            end
        end
        
        -- Tecla L (código 182)
        if IsControlJustPressed(0, 182) then
            if isCuffed then
                RemoveLocalCuffs()
                ShowNotification("~g~[SUSANO]~w~ Te has liberado")
            else
                -- Intentar liberar a otro? (no recomendado)
                ShowNotification("~y~[SUSANO]~w~ No estás esposado")
            end
        end
    end
end)

-- Limpiar estado al reaparecer
AddEventHandler('playerSpawned', function()
    if isCuffed then
        RemoveLocalCuffs()
    end
end)
