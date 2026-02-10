RegisterServerEvent('rframework:server:saveCharacter', function(charData)
    local src = source
    local Player = RFramework.Players[src]
    if not Player or not Player.PlayerData.activeChar then return end
    local currentChar = json.decode(Player.PlayerData.activeChar.skin) or {}
    if charData.appearance and charData.appearance.model then currentChar.model = charData.appearance.model end
    if charData.appearance and charData.appearance.components then
        for id, comp in pairs(charData.appearance.components) do
            currentChar.components[id] = comp
        end
    end
    MySQL.update.await('UPDATE characters SET skin = ? WHERE char_id = ?', {json.encode(currentChar), Player.PlayerData.activeChar.char_id})
    Player.PlayerData.activeChar.skin = json.encode(currentChar)
    RFramework.Notify(src, 'Character saved!', 'success')
end)

exports('GetPlayerCharacter', function(src)
    local Player = RFramework.Players[src]
    return json.decode(Player.PlayerData.activeChar.skin) or {}
end)