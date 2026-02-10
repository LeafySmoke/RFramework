exports('AddMoney', function(src, amount)
    local Player = exports['rframework']:GetPlayer(src)
    if Player then
        Player.PlayerData.money = Player.PlayerData.money + amount
        exports.ox_inventory:AddItem(src, 'money', amount)
        RFramework.Notify(src, 'Added $' .. amount, 'success')
    end
end)

exports('RemoveMoney', function(src, amount)
    local Player = exports['rframework']:GetPlayer(src)
    if Player and Player.PlayerData.money >= amount then
        Player.PlayerData.money = Player.PlayerData.money - amount
        exports.ox_inventory:RemoveItem(src, 'money', amount)
        return true
    end
    return false
end)