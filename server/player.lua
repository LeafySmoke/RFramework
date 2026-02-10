-- RFramework Player Management (Server)

-- Get player object
RFramework.GetPlayer = function(source)
    return RFramework.Players[source]
end

-- Create new player
RFramework.CreatePlayer = function(source, identifier, name)
    local playerData = {
        source = source,
        identifier = identifier,
        name = name,
        money = Config.Player.StartingMoney,
        bank = Config.Player.StartingBank,
        job = {
            name = Config.Player.DefaultJobName,
            grade = Config.Player.DefaultJobGrade,
            label = Config.Jobs[Config.Player.DefaultJobName].label,
            grade_label = Config.Jobs[Config.Player.DefaultJobName].grades[Config.Player.DefaultJobGrade].name,
            salary = Config.Jobs[Config.Player.DefaultJobName].grades[Config.Player.DefaultJobGrade].salary
        },
        inventory = {},
        metadata = {}
    }
    
    RFramework.Players[source] = playerData
    
    -- Trigger client event
    TriggerClientEvent('rframework:playerLoaded', source, playerData)
    
    RFramework.Utils.DebugPrint('Player created: ' .. name .. ' [' .. identifier .. ']')
    
    return playerData
end

-- Load player from database
RFramework.LoadPlayer = function(source)
    local identifier = GetPlayerIdentifier(source)
    local name = GetPlayerName(source)
    
    if not identifier then
        print('[RFramework] ERROR: No identifier found for player ' .. source)
        return nil
    end
    
    -- For now, create a new player (database loading will be implemented in database.lua)
    local player = RFramework.CreatePlayer(source, identifier, name)
    
    return player
end

-- Save player data
RFramework.SavePlayer = function(source)
    local player = RFramework.GetPlayer(source)
    
    if not player then
        return false
    end
    
    -- Database save will be implemented in database.lua
    RFramework.Utils.DebugPrint('Player saved: ' .. player.name)
    
    return true
end

-- Add money to player
RFramework.AddMoney = function(source, account, amount)
    local player = RFramework.GetPlayer(source)
    
    if not player then
        return false
    end
    
    if account == 'money' then
        player.money = player.money + amount
    elseif account == 'bank' then
        player.bank = player.bank + amount
    else
        return false
    end
    
    TriggerClientEvent('rframework:updateMoney', source, account, player[account])
    
    return true
end

-- Remove money from player
RFramework.RemoveMoney = function(source, account, amount)
    local player = RFramework.GetPlayer(source)
    
    if not player then
        return false
    end
    
    if account == 'money' then
        if player.money >= amount then
            player.money = player.money - amount
        else
            return false
        end
    elseif account == 'bank' then
        if player.bank >= amount then
            player.bank = player.bank - amount
        else
            return false
        end
    else
        return false
    end
    
    TriggerClientEvent('rframework:updateMoney', source, account, player[account])
    
    return true
end

-- Set player job
RFramework.SetJob = function(source, jobName, grade)
    local player = RFramework.GetPlayer(source)
    
    if not player then
        return false
    end
    
    if not Config.Jobs[jobName] then
        return false
    end
    
    local job = Config.Jobs[jobName]
    local jobGrade = job.grades[grade]
    
    if not jobGrade then
        return false
    end
    
    player.job = {
        name = jobName,
        grade = grade,
        label = job.label,
        grade_label = jobGrade.name,
        salary = jobGrade.salary
    }
    
    TriggerClientEvent('rframework:updateJob', source, player.job)
    
    return true
end

-- Server callbacks for player data
RFramework.RegisterServerCallback('rframework:getPlayerData', function(source, cb)
    local player = RFramework.GetPlayer(source)
    
    if player then
        cb(player)
    else
        cb(nil)
    end
end)

-- Handle player ready event
RegisterNetEvent('rframework:playerReady')
AddEventHandler('rframework:playerReady', function()
    local source = source
    
    -- Load or create player
    RFramework.LoadPlayer(source)
end)
