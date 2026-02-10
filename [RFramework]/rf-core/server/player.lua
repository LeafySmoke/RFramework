RFramework.Players = {}

RegisterServerEvent('rframework:server:playerLoaded', function()
    local src = source
    local license = GetPlayerIdentifier(src, 'license:')
    local result = MySQL.query.await('SELECT * FROM players WHERE license = ?', {license})
    
    if not result[1] then
        MySQL.insert.await('INSERT INTO players (license, money, job) VALUES (?, ?, ?)', {license, Config.StartingMoney, Config.DefaultJob})
        result = {{money = Config.StartingMoney, job = Config.DefaultJob}}
    end
    
    RFramework.Players[src] = {
        PlayerData = { source = src, license = license, money = result[1].money, job = result[1].job }
    }
    
    -- Load chars here for multi-char
    local chars = MySQL.query.await('SELECT * FROM characters WHERE license = ?', {license})
    if #chars == 0 then
        MySQL.insert.await('INSERT INTO characters (license, first_name, last_name) VALUES (?, ?, ?)', {license, 'John', 'Doe'})
        chars = MySQL.query.await('SELECT * FROM characters WHERE license = ?', {license})
    end
    RFramework.Players[src].PlayerData.chars = chars
    RFramework.Players[src].PlayerData.activeChar = chars[1]
    RFramework.Players[src].PlayerData.citizenid = chars[1].char_id  -- For inventory/bridges
    
    -- Register stashes
    for _, char in ipairs(chars) do
        exports['rframework']:RegisterCharStash(char.char_id)
    end
    
    -- Initial inv swap
    TriggerServerEvent('rframework:server:swapInventory', 0, chars[1].char_id)
    
    TriggerClientEvent('rframework:client:playerLoaded', src, RFramework.Players[src].PlayerData)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if RFramework.Players[src] then
        MySQL.update.await('UPDATE players SET money = ?, job = ? WHERE license = ?', {
            RFramework.Players[src].PlayerData.money, RFramework.Players[src].PlayerData.job, RFramework.Players[src].PlayerData.license
        })
        RFramework.Players[src] = nil
    end
end)

exports('GetPlayer', function(src) return RFramework.Players[src] end)