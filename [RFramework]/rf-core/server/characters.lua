RegisterServerEvent('rframework:server:switchChar', function(charId)
    local src = source
    local Player = RFramework.Players[src]
    if not Player then return end
    
    for _, char in ipairs(Player.PlayerData.chars) do
        if char.char_id == charId then
            -- Save old character if exists
            if Player.PlayerData.activeChar then
                MySQL.update.await('UPDATE characters SET position = ?, skin = ? WHERE char_id = ?', {
                    json.encode(Player.PlayerData.position or {}), 
                    Player.PlayerData.activeChar.skin or '{}', 
                    Player.PlayerData.activeChar.char_id
                })
                -- Swap inventory
                TriggerServerEvent('rframework:server:swapInventory', Player.PlayerData.activeChar.char_id, charId)
            else
                -- First time selecting a character, just load inventory
                TriggerServerEvent('rframework:server:swapInventory', 0, charId)
            end
            
            -- Set active character
            Player.PlayerData.activeChar = char
            Player.PlayerData.citizenid = charId
            
            -- Load character appearance
            local charData = {appearance = json.decode(char.skin) or {model = 'mp_m_freemode_01', components = {}}}
            TriggerClientEvent('rframework:client:loadCharacter', src, charData)
            
            RFramework.Notify(src, 'Character loaded: ' .. char.first_name .. ' ' .. char.last_name, 'success')
            return
        end
    end
    
    RFramework.Notify(src, 'Character not found!', 'error')
end)

RegisterServerEvent('rframework:server:createCharacter', function(firstName, lastName)
    local src = source
    local Player = RFramework.Players[src]
    if not Player then return end
    
    -- Check if player already has max characters (default 5)
    if #Player.PlayerData.chars >= 5 then
        RFramework.Notify(src, 'Maximum character limit reached!', 'error')
        return
    end
    
    -- Create new character
    local charId = MySQL.insert.await('INSERT INTO characters (license, first_name, last_name, skin) VALUES (?, ?, ?, ?)', {
        Player.PlayerData.license, firstName, lastName, json.encode({model = 'mp_m_freemode_01', components = {}})
    })
    
    -- Reload characters
    local chars = MySQL.query.await('SELECT * FROM characters WHERE license = ?', {Player.PlayerData.license})
    Player.PlayerData.chars = chars
    
    -- Register stash for new character
    exports['rframework']:RegisterCharStash(charId)
    
    RFramework.Notify(src, 'Character created successfully!', 'success')
    TriggerClientEvent('rframework:client:refreshCharacters', src, chars)
end)

RegisterServerEvent('rframework:server:deleteCharacter', function(charId)
    local src = source
    local Player = RFramework.Players[src]
    if not Player then return end
    
    -- Prevent deleting active character
    if Player.PlayerData.activeChar and Player.PlayerData.activeChar.char_id == charId then
        RFramework.Notify(src, 'Cannot delete active character! Switch to another character first.', 'error')
        return
    end
    
    -- Prevent deleting last character
    if #Player.PlayerData.chars <= 1 then
        RFramework.Notify(src, 'Cannot delete your only character!', 'error')
        return
    end
    
    -- Delete character
    MySQL.query.await('DELETE FROM characters WHERE char_id = ? AND license = ?', {charId, Player.PlayerData.license})
    
    -- Reload characters
    local chars = MySQL.query.await('SELECT * FROM characters WHERE license = ?', {Player.PlayerData.license})
    Player.PlayerData.chars = chars
    
    RFramework.Notify(src, 'Character deleted successfully!', 'success')
    TriggerClientEvent('rframework:client:refreshCharacters', src, chars)
end)