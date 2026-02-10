RegisterServerEvent('rframework:server:saveVehicle', function(plate, model, props)
    local src = source
    local Player = RFramework.Players[src]
    MySQL.insert.await('INSERT INTO vehicles (plate, owner_license, model, props) VALUES (?, ?, ?, ?)', {plate, Player.PlayerData.license, model, json.encode(props)})
end)

RegisterServerEvent('rframework:server:loadVehicles', function()
    local src = source
    local Player = RFramework.Players[src]
    local vehicles = MySQL.query.await('SELECT * FROM vehicles WHERE owner_license = ?', {Player.PlayerData.license})
    TriggerClientEvent('rframework:client:spawnVehicles', src, vehicles)
end)