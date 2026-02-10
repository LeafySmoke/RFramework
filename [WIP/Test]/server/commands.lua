-- RFramework Server Commands

-- Give money command
RegisterCommand('givemoney', function(source, args, rawCommand)
    if source == 0 then
        -- Console command
        local targetId = tonumber(args[1])
        local account = args[2] or 'money'
        local amount = tonumber(args[3]) or 0
        
        if targetId and amount > 0 then
            if RFramework.AddMoney(targetId, account, amount) then
                print('[RFramework] Added $' .. amount .. ' to player ' .. targetId .. ' (' .. account .. ')')
            else
                print('[RFramework] Failed to add money to player ' .. targetId)
            end
        else
            print('[RFramework] Usage: givemoney <player_id> <money|bank> <amount>')
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[RFramework]', 'This command can only be used from the server console' }
        })
    end
end, false)

-- Set job command
RegisterCommand('setjob', function(source, args, rawCommand)
    if source == 0 then
        -- Console command
        local targetId = tonumber(args[1])
        local jobName = args[2]
        local grade = tonumber(args[3]) or 0
        
        if targetId and jobName then
            if RFramework.SetJob(targetId, jobName, grade) then
                print('[RFramework] Set player ' .. targetId .. ' job to ' .. jobName .. ' (grade: ' .. grade .. ')')
            else
                print('[RFramework] Failed to set job for player ' .. targetId)
            end
        else
            print('[RFramework] Usage: setjob <player_id> <job_name> <grade>')
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[RFramework]', 'This command can only be used from the server console' }
        })
    end
end, false)

-- Save all players command
RegisterCommand('saveall', function(source, args, rawCommand)
    if source == 0 then
        print('[RFramework] Saving all player data...')
        
        local count = 0
        for playerId, _ in pairs(RFramework.Players) do
            if RFramework.SavePlayer(playerId) then
                count = count + 1
            end
        end
        
        print('[RFramework] Saved ' .. count .. ' players')
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[RFramework]', 'This command can only be used from the server console' }
        })
    end
end, false)

-- Player info command
RegisterCommand('playerinfo', function(source, args, rawCommand)
    if source == 0 then
        local targetId = tonumber(args[1])
        
        if targetId then
            local player = RFramework.GetPlayer(targetId)
            
            if player then
                print('[RFramework] Player Info for ' .. player.name .. ':')
                print('  Identifier: ' .. player.identifier)
                print('  Money: $' .. player.money)
                print('  Bank: $' .. player.bank)
                print('  Job: ' .. player.job.label .. ' - ' .. player.job.grade_label .. ' (Salary: $' .. player.job.salary .. ')')
            else
                print('[RFramework] Player not found: ' .. targetId)
            end
        else
            print('[RFramework] Usage: playerinfo <player_id>')
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { '[RFramework]', 'This command can only be used from the server console' }
        })
    end
end, false)
