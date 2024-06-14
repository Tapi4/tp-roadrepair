local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add('startrepairjob', 'Start a road repair job', {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('tp-roadrepair:startJob', source)
end)

RegisterNetEvent('tp-roadrepair:completeJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local reward = math.random(200, 400)
        Player.Functions.AddMoney('cash', reward, 'Completed road repair job')
        TriggerClientEvent('QBCore:Notify', src, 'You have been paid $' .. reward .. ' for completing the road repair job.', 'success')
    end
end)
