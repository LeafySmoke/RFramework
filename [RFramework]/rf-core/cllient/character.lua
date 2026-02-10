local RFramework = exports['rframework']:GetCoreObject()

RegisterNetEvent('rframework:client:loadCharacter', function(charData)
    local playerPed = PlayerPedId()
    RequestModel(GetHashKey(charData.appearance.model))
    while not HasModelLoaded(GetHashKey(charData.appearance.model)) do
        Citizen.Wait(0)
    end
    SetPlayerModel(PlayerId(), GetHashKey(charData.appearance.model))
    SetPedDefaultComponentVariation(playerPed)
    for componentId, data in pairs(charData.appearance.components) do
        SetPedComponentVariation(playerPed, componentId, data.drawable, data.texture, data.palette)
    end
end)

RegisterNetEvent('rframework:client:openCharacterMenu', function()
    local menuOptions = {
        {title = 'Change Model', onSelect = function()
            local newModel = 'mp_m_freemode_01'
            TriggerServerEvent('rframework:server:saveCharacter', {appearance = {model = newModel}})
        end},
        {title = 'Clothing', submenu = {
            {title = 'Torso', onSelect = function()
                local ped = PlayerPedId()
                local current = GetPedDrawableVariation(ped, 3)
                SetPedComponentVariation(ped, 3, current + 1, 0, 0)
                TriggerServerEvent('rframework:server:saveCharacter', {appearance = {components = { [3] = {drawable = current + 1, texture = 0, palette = 0}}}})
            end},
        }},
        {title = 'Save & Close', onSelect = function()
            local fullChar = GetCurrentCharacter()
            TriggerServerEvent('rframework:server:saveCharacter', fullChar)
        end}
    }
    lib.showContext({id = 'character_menu', title = 'Character Editor', options = menuOptions})
end)

function GetCurrentCharacter()
    local ped = PlayerPedId()
    local char = {appearance = {model = GetEntityModel(ped), components = {}}}
    for i = 0, 11 do
        char.appearance.components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i),
            palette = GetPedPaletteVariation(ped, i)
        }
    end
    return char
end

-- Admin menu (add to client/main.lua if separate, but here for completeness)
RegisterNetEvent('rframework:client:showAdminMenu', function()
    lib.showContext({
        id = 'admin_menu',
        title = 'Admin Menu',
        options = {
            {title = 'Teleport', onSelect = function()
                local coords = GetEntityCoords(PlayerPedId())
                TriggerServerEvent('rframework:server:adminTeleport', coords)
            end}
        }
    })
end)