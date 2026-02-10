RegisterCommand('kick', function(source, args)
    if IsPlayerAceAllowed(source, 'admin') then
        local target = tonumber(args[1])
        local reason = table.concat(args, ' ', 2) or 'No reason'
        DropPlayer(target, 'Kicked: ' .. reason)
    else
        RFramework.Notify(source, 'No permission', 'error')
    end
end, true)

RegisterServerEvent('rframework:server:openAdminMenu', function()
    local src = source
    if IsPlayerAceAllowed(src, 'admin') then
        TriggerClientEvent('rframework:client:showAdminMenu', src)
    else
        RFramework.Notify(src, 'No permission', 'error')
    end
end)

RegisterServerEvent('rframework:server:adminTeleport', function(targetCoords)
    local src = source
    if IsPlayerAceAllowed(src, 'admin') then
        TriggerClientEvent('rframework:client:teleport', src, targetCoords)
    end
end)

RegisterCommand('character', function(source, args)
    if IsPlayerAceAllowed(source, 'admin') then
        TriggerClientEvent('rframework:client:openCharacterMenu', source)
    end
end, false)