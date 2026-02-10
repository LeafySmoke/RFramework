local RFramework = exports['rframework']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        print('RFramework started!')
    end
end)

exports.ox_doorlock:registerDoor({
    hash = GetHashKey('prop_door_01'),
    coords = vector3(0,0,0),
    groups = {'police'},
    state = 1
})

-- Auto-save loop
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        for src, Player in pairs(RFramework.Players) do
            MySQL.update.await('UPDATE players SET money = ? WHERE license = ?', {Player.PlayerData.money, Player.PlayerData.license})
        end
        print('Auto-saved players')
    end
end)

-- Custom event example
RegisterServerEvent('rframework:server:customEvent', function(data)
    local src = source
    print('Custom event from ' .. src .. ': ' .. data)
end)