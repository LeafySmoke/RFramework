-- RFramework Server Main Script

print([[
    ^3
    ____  ______                                            __  
   / __ \/ ____/________ _____ ___  ___ _      ______  _____/ /__
  / /_/ / /_  / ___/ __ `/ __ `__ \/ _ \ | /| / / __ \/ ___/ //_/
 / _, _/ __/ / /  / /_/ / / / / / /  __/ |/ |/ / /_/ / /  / ,<   
/_/ |_/_/   /_/   \__,_/_/ /_/ /_/\___/|__/|__/\____/_/  /_/|_|  
                                                                  
    ^2RFramework v^3]] .. Config.Framework.Version .. [[^2 - Server Starting...
    ^7Author: LeafySmoke
    ^0
]])

RFramework.Players = {}

-- Framework initialization
Citizen.CreateThread(function()
    RFramework.Utils.DebugPrint('Server initializing...')
    
    -- Initialize database if enabled
    if Config.Database.Enabled then
        RFramework.InitializeDatabase()
    end
    
    print('[RFramework] ^2Server initialized successfully!^7')
end)

-- Player connecting
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local identifier = GetPlayerIdentifier(source)
    
    deferrals.defer()
    
    Wait(0)
    
    deferrals.update('[RFramework] Checking player data...')
    
    Wait(500)
    
    RFramework.Utils.DebugPrint('Player connecting: ' .. name .. ' [' .. identifier .. ']')
    
    deferrals.done()
end)

-- Player joined
AddEventHandler('playerJoining', function()
    local source = source
    RFramework.Utils.DebugPrint('Player joining: ' .. source)
end)

-- Player dropped
AddEventHandler('playerDropped', function(reason)
    local source = source
    
    if RFramework.Players[source] then
        RFramework.SavePlayer(source)
        RFramework.Players[source] = nil
        RFramework.Utils.DebugPrint('Player dropped: ' .. source .. ' - Reason: ' .. reason)
    end
end)

-- Resource stop event - save all players
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print('[RFramework] Saving all player data before shutdown...')
        
        for playerId, _ in pairs(RFramework.Players) do
            RFramework.SavePlayer(playerId)
        end
        
        print('[RFramework] All player data saved!')
    end
end)

-- Get framework version command
RegisterCommand('rfversion', function(source, args, rawCommand)
    if source == 0 then
        print('[RFramework] Version: ' .. Config.Framework.Version)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[RFramework]', 'Version: ' .. Config.Framework.Version }
        })
    end
end, false)

-- Get online players command
RegisterCommand('rfonline', function(source, args, rawCommand)
    local playerCount = #GetPlayers()
    local message = 'Players online: ' .. playerCount
    
    if source == 0 then
        print('[RFramework] ' .. message)
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[RFramework]', message }
        })
    end
end, false)

-- Export functions
exports('GetSharedObject', function()
    return RFramework
end)
