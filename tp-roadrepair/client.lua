local QBCore = exports['qb-core']:GetCoreObject()
local onJob = false
local currentJob = nil
local pedModel = `a_m_y_business_02`
local pedCoords = vector3(92.16, -605.08, 30.6)
local pedHeading = 180.0

function HasToolbox()
    local player = QBCore.Functions.GetPlayerData()

    for k, v in pairs(player.items) do
        if v.name == Config.RequiredItem and v.amount >= Config.RequiredQuantity then
            return true
        end
    end

    return false
end

RegisterNetEvent('tp-roadrepair:startJob', function()
    if onJob then
        QBCore.Functions.Notify('You are already on a job!', 'error')
        return
    end

    if not HasToolbox() then
        QBCore.Functions.Notify('You need a toolbox to start the repair job!', 'error')
        return
    end

    onJob = true
    currentJob = Config.JobLocations[math.random(#Config.JobLocations)]
    SetNewWaypoint(currentJob.x, currentJob.y)

    QBCore.Functions.Notify('Go to the marked location to start the repair job!', 'success')
end)

function StartRepair()
    QBCore.Functions.Notify('Repairing the road...', 'success')
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic3"}) 

    local duration = 10000 

    exports['progressbar']:Progress({
        name = 'tp-roadrepair',
        duration = duration,
        label = 'Repairing the road...',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@world_human_const_drill@male@drill@idle_a",
            anim = "idle_a",
            flags = 49,
        },
        prop = {
            model = "prop_tool_drill", 
            bone = 28422, 
            coords = { x = 0.10, y = 0.05, z = 0.08 },
            rotation = { x = -180.0, y = -100.0, z = 30.0 },
        }
    }, function(cancelled)
        if not cancelled then
            QBCore.Functions.Notify('Road repair completed!', 'success')
            TriggerServerEvent('tp-roadrepair:completeJob') 
        else
            QBCore.Functions.Notify('Repair interrupted.', 'error')
        end

        TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
        onJob = false
    end)
end

function ShowMemoryGame()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "show_memory_game"
    })
end

RegisterNUICallback('memoryGameCompleted', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "hide_memory_game"
    })
    StartRepair()
    cb('ok')
end)

CreateThread(function()
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end

    local ped = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z, pedHeading, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "client",
                event = "tp-roadrepair:startJob",
                icon = "fas fa-hard-hat",
                label = "Start Road Repair Job"
            }
        },
        distance = 2.5
    })

end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropShadow(0, 0, 0, 185)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawMarker3D(x, y, z, r, g, b, radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local dist = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, x, y, z, true)

    if dist <= radius then
        DrawMarker(25, x, y, z - 1.0, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, r, g, b, 200, false, true, 2, false, nil, nil, false)

        if dist <= 1.5 then
            DrawText3D(x, y, z + 0.4, "[E] Start Repair")
            if IsControlJustReleased(0, 38) then 
                ShowMemoryGame() 
            end
        end
    end
end


CreateThread(function()
    while true do
        Wait(0)
        if onJob and currentJob then
            DrawMarker3D(currentJob.x, currentJob.y, currentJob.z, 0, 0, 255, 20.0)
        end
    end
end)

CreateThread(function()
    local roadrepair = AddBlipForCoord(92.16, -605.08, 30.6)
    SetBlipSprite(roadrepair, 544)
    SetBlipDisplay(roadrepair, 4)
    SetBlipScale(roadrepair, 1.2)
    SetBlipAsShortRange(roadrepair, true)
    SetBlipColour(roadrepair, 8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Road Repair Job")
    EndTextCommandSetBlipName(roadrepair)
end)
