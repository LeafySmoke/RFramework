RegisterServerEvent('rframework:server:switchChar', function(charId)
    local src = source
    local Player = RFramework.Players[src]
    for _, char in ipairs(Player.PlayerData.chars) do
        if char.char_id == charId then
            -- Save old
            MySQL.update.await('UPDATE characters SET position = ?, skin = ? WHERE char_id = ?', {
                json.encode(Player.PlayerData.position), Player.PlayerData.activeChar.skin, Player.PlayerData.activeChar.char_id
            })
            
            -- Swap inv
            TriggerServerEvent('rframework:server:swapInventory', Player.PlayerData.activeChar.char_id, charId)
            
            Player.PlayerData.activeChar = char
            Player.PlayerData.citizenid = charId
            local charData = {appearance = json.decode(char.skin) or {model = 'mp_m_freemode_01', components = {}}}
            TriggerClientEvent('rframework:client:loadCharacter', src, charData)
            return
        end
    end
end)