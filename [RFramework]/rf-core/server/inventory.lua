local ox_inv = exports.ox_inventory

function RegisterCharStash(charId)
    local stashId = 'char_' .. charId
    ox_inv:RegisterStash(stashId, 'Character Inventory', 50, 250000, true)
end

exports('RegisterCharStash', RegisterCharStash)

RegisterServerEvent('rframework:server:swapInventory', function(oldCharId, newCharId)
    local src = source
    
    -- Handle first-time character selection (no old character)
    if oldCharId == 0 or oldCharId == nil then
        RegisterCharStash(newCharId)
        local stashItems = ox_inv:GetInventoryItems('char_' .. newCharId)
        for _, item in ipairs(stashItems) do
            ox_inv:AddItem(src, item.name, item.count, item.metadata, item.slot)
        end
        RFramework.Notify(src, 'Character inventory loaded!', 'success')
        return
    end
    
    -- Normal swap between characters
    RegisterCharStash(oldCharId)
    RegisterCharStash(newCharId)
    local playerItems = ox_inv:GetInventoryItems(src)
    ox_inv:ClearInventory(src)
    for _, item in ipairs(playerItems) do
        ox_inv:AddItem('char_' .. oldCharId, item.name, item.count, item.metadata, item.slot)
    end
    local stashItems = ox_inv:GetInventoryItems('char_' .. newCharId)
    for _, item in ipairs(stashItems) do
        ox_inv:AddItem(src, item.name, item.count, item.metadata, item.slot)
    end
    RFramework.Notify(src, 'Inventory loaded for new character!', 'success')
end)