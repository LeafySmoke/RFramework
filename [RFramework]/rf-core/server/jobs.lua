RegisterServerEvent('rframework:server:setPlayerJob', function(jobName)
    local src = source
    local Player = exports['rframework']:GetPlayer(src)
    if Player and Config.Jobs[jobName] then
        Player.PlayerData.job = jobName
        TriggerClientEvent('rframework:client:setJob', src, jobName)
        RFramework.Notify(src, 'Job changed to ' .. Config.Jobs[jobName].label, 'success')
        MySQL.update.await('UPDATE players SET job = ? WHERE license = ?', {jobName, Player.PlayerData.license})
    end
end)

RegisterCommand('setjob', function(source, args)
    local target = tonumber(args[1])
    local job = args[2]
    TriggerServerEvent('rframework:server:setPlayerJob', job)
end, true)