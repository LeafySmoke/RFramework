local RFramework = exports['rframework']:GetCoreObject()
local playerCharacters = {}

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

-- Character Selection Menu
RegisterNetEvent('rframework:client:showCharacterSelection', function(characters)
    playerCharacters = characters
    OpenCharacterSelectionMenu()
end)

RegisterNetEvent('rframework:client:refreshCharacters', function(characters)
    playerCharacters = characters
    OpenCharacterSelectionMenu()
end)

function OpenCharacterSelectionMenu()
    local menuOptions = {}
    
    -- Add existing characters to menu
    for _, char in ipairs(playerCharacters) do
        table.insert(menuOptions, {
            title = char.first_name .. ' ' .. char.last_name,
            description = 'Character ID: ' .. char.char_id,
            icon = 'user',
            onSelect = function()
                TriggerServerEvent('rframework:server:switchChar', char.char_id)
            end,
            metadata = {
                {label = 'Delete', value = 'Hold E to delete'}
            }
        })
    end
    
    -- Add create character option if under max limit
    if #playerCharacters < 5 then
        table.insert(menuOptions, {
            title = 'Create New Character',
            description = 'Create a new character',
            icon = 'plus',
            onSelect = function()
                OpenCharacterCreationMenu()
            end
        })
    end
    
    lib.showContext({
        id = 'character_selection',
        title = 'Character Selection',
        options = menuOptions
    })
end

function OpenCharacterCreationMenu()
    local input = lib.inputDialog('Create Character', {
        {type = 'input', label = 'First Name', description = 'Enter first name', required = true, min = 2, max = 50},
        {type = 'input', label = 'Last Name', description = 'Enter last name', required = true, min = 2, max = 50}
    })
    
    if input then
        local firstName = input[1]
        local lastName = input[2]
        TriggerServerEvent('rframework:server:createCharacter', firstName, lastName)
    end
end

-- Command to open character selection
RegisterCommand('characters', function()
    if #playerCharacters > 0 then
        OpenCharacterSelectionMenu()
    else
        lib.notify({
            title = 'Error',
            description = 'No characters available',
            type = 'error'
        })
    end
end, false)

-- Delete character command (alternative to context menu)
RegisterCommand('deletechar', function(source, args)
    if not args[1] then
        lib.notify({
            title = 'Error',
            description = 'Usage: /deletechar [char_id]',
            type = 'error'
        })
        return
    end
    
    local charId = tonumber(args[1])
    if not charId then
        lib.notify({
            title = 'Error',
            description = 'Invalid character ID',
            type = 'error'
        })
        return
    end
    
    -- Confirm deletion
    local alert = lib.alertDialog({
        header = 'Delete Character',
        content = 'Are you sure you want to delete this character? This action cannot be undone!',
        centered = true,
        cancel = true
    })
    
    if alert == 'confirm' then
        TriggerServerEvent('rframework:server:deleteCharacter', charId)
    end
end, false)