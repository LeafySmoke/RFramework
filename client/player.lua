-- RFramework Client Player Functions

-- Spawn player at default location
RFramework.SpawnPlayer = function(cb)
    local spawnLocation = Config.Spawn.Locations[math.random(#Config.Spawn.Locations)]
    
    RequestCollisionAtCoord(spawnLocation.coords.x, spawnLocation.coords.y, spawnLocation.coords.z)
    
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        
        SetEntityCoordsNoOffset(playerPed, spawnLocation.coords.x, spawnLocation.coords.y, spawnLocation.coords.z, false, false, false, true)
        SetEntityHeading(playerPed, spawnLocation.heading)
        
        -- Freeze player temporarily
        FreezeEntityPosition(playerPed, true)
        
        -- Wait for collision
        while not HasCollisionLoadedAroundEntity(playerPed) do
            Citizen.Wait(0)
        end
        
        -- Unfreeze player
        FreezeEntityPosition(playerPed, false)
        
        if cb then
            cb()
        end
    end)
end

-- Teleport player
RFramework.TeleportPlayer = function(coords, heading)
    local playerPed = PlayerPedId()
    
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    
    SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false, true)
    
    if heading then
        SetEntityHeading(playerPed, heading)
    end
    
    -- Wait for collision
    while not HasCollisionLoadedAroundEntity(playerPed) do
        Citizen.Wait(0)
    end
end

-- Revive player
RFramework.RevivePlayer = function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    -- Reset player state
    SetEntityInvincible(playerPed, false)
    SetPlayerInvincible(PlayerId(), false)
    SetPedCanRagdoll(playerPed, true)
    ClearPedBloodDamage(playerPed)
    SetPedArmour(playerPed, 0)
    
    -- Revive
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(playerPed), true, false)
    SetPlayerInvincible(PlayerId(), false)
    ClearPedTasksImmediately(playerPed)
    
    -- Set health
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end

-- Set player health
RFramework.SetPlayerHealth = function(health)
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)
    
    if health > maxHealth then
        health = maxHealth
    end
    
    SetEntityHealth(playerPed, health)
end

-- Set player armour
RFramework.SetPlayerArmour = function(armour)
    local playerPed = PlayerPedId()
    
    if armour > 100 then
        armour = 100
    end
    
    SetPedArmour(playerPed, armour)
end

-- Get closest player
RFramework.GetClosestPlayer = function(radius)
    local players = GetActivePlayers()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer = -1
    local closestDistance = radius or 5.0
    
    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            
            if distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    
    return closestPlayer, closestDistance
end
