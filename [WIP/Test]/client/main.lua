-- RFramework Client Main Script

local PlayerLoaded = false
local PlayerData = nil

-- Wait for game to load
Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(0)
    end
    
    print('[RFramework] ^2Client initialized^7')
    
    -- Notify server that player is ready
    TriggerServerEvent('rframework:playerReady')
end)

-- Player loaded event
RegisterNetEvent('rframework:playerLoaded')
AddEventHandler('rframework:playerLoaded', function(playerData)
    PlayerData = playerData
    PlayerLoaded = true
    
    print('[RFramework] Player data loaded!')
    
    -- Trigger custom event for other scripts
    TriggerEvent('rframework:onPlayerLoaded', PlayerData)
end)

-- Update money event
RegisterNetEvent('rframework:updateMoney')
AddEventHandler('rframework:updateMoney', function(account, amount)
    if PlayerData then
        PlayerData[account] = amount
        TriggerEvent('rframework:onMoneyChange', account, amount)
    end
end)

-- Update job event
RegisterNetEvent('rframework:updateJob')
AddEventHandler('rframework:updateJob', function(job)
    if PlayerData then
        PlayerData.job = job
        TriggerEvent('rframework:onJobChange', job)
    end
end)

-- Export functions
RFramework = {}

RFramework.IsPlayerLoaded = function()
    return PlayerLoaded
end

RFramework.GetPlayerData = function()
    return PlayerData
end

RFramework.RefreshPlayerData = function(cb)
    RFramework.TriggerServerCallback('rframework:getPlayerData', function(data)
        PlayerData = data
        if cb then
            cb(data)
        end
    end)
end

-- Export for other resources
exports('GetPlayerLoaded', function()
    return PlayerLoaded
end)

exports('GetPlayerData', function()
    return PlayerData
end)

exports('GetSharedObject', function()
    return RFramework
end)
