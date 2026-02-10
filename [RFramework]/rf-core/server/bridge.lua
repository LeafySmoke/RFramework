-- Global QB mimic
QBCore = {}
QBCore.Functions = {}
QBCore.Player = {}  -- For player methods if needed
QBCore.Config = Config  -- Share our config (or map qb keys)

-- Core export: GetCoreObject (qb calls this)
exports('GetSharedObject', function() return QBCore end)  -- Other resources: local QBCore = exports['rframework']:GetSharedObject()

-- Player functions
QBCore.Functions.GetPlayer = function(src)
    local ourPlayer = exports['rframework']:GetPlayer(src)
    if not ourPlayer then return nil end
    
    -- Map to qb-style PlayerData (teaches table remapping)
    return {
        PlayerData = {
            source = ourPlayer.PlayerData.source,
            citizenid = ourPlayer.PlayerData.citizenid,  -- From multi-char
            cid = ourPlayer.PlayerData.citizenid,  -- Alias
            license = ourPlayer.PlayerData.license,
            name = 'Unknown',  -- Add from char if expanded
            money = {cash = ourPlayer.PlayerData.money, bank = 0},  -- Expand if adding bank
            job = {name = ourPlayer.PlayerData.job, label = Config.Jobs[ourPlayer.PlayerData.job].label, grade = {level = 0}},
            -- Add more: gang, metadata, etc.
        },
        Functions = {
            -- Wrapper example: SetJob (calls our event)
            SetJob = function(job, grade)
                TriggerServerEvent('rframework:server:setPlayerJob', job)
            end,
            -- AddMoney (maps to our export)
            AddMoney = function(account, amount)
                if account == 'cash' then
                    exports['rframework']:AddMoney(src, amount)
                end
            end,
            -- More as needed
        }
    }
end

QBCore.Functions.GetPlayerByCitizenId = function(citizenid)
    -- Loop through players (teaches pairs iteration)
    for src, Player in pairs(RFramework.Players) do
        if Player.PlayerData.citizenid == citizenid then
            return QBCore.Functions.GetPlayer(src)
        end
    end
    return nil
end

-- Notify wrapper
QBCore.Functions.Notify = function(src, text, type, length)
    RFramework.Notify(src, text, type)  -- Our ox_lib wrapper
end

-- Vehicle functions (qb common)
QBCore.Functions.GetVehicleProperties = function(vehicle)
    -- Native to get props (teaches GTA natives)
    local props = {}
    props.model = GetEntityModel(vehicle)
    props.plate = GetVehicleNumberPlateText(vehicle)
    -- Add colors, mods: GetVehicleColours, GetVehicleMod, etc.
    return props
end

QBCore.Functions.SetVehicleProperties = function(vehicle, props)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNumberPlateText(vehicle, props.plate)
    -- Set more: SetVehicleColours, SetVehicleMod
end

-- Spawn vehicle (example wrapper)
QBCore.Functions.SpawnVehicle = function(model, cb, coords, isnetworked)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(0) end
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w, isnetworked, false)
    if cb then cb(veh) end
end

-- Callback registry (table to store handlers)
local serverCallbacks = {}
local callbackRequests = {}  -- Track pending requests: requestId -> {src, cb}

-- Unique ID generator (simple random string—teaches string concat/math.random)
local function generateRequestId()
    return 'cb_' .. math.random(100000, 999999) .. '_' .. GetGameTimer()  -- Timestamp for uniqueness
end

-- QB-style: RegisterServerCallback (server registers handler for a named callback)
QBCore.Functions.RegisterServerCallback = function(name, cb)
    if type(name) ~= 'string' or type(cb) ~= 'function' then
        print('^1[Bridge Error] Invalid callback registration: ' .. name)  -- Debug print (teaches logging)
        return
    end
    serverCallbacks[name] = cb
    print('^2[Bridge] Registered server callback: ' .. name)  -- ^2 green color in console
end

-- Internal event: Client triggers this to start callback
RegisterServerEvent('rframework:qb:triggerServerCallback', function(name, requestId, ...)
    local src = source
    local args = {...}  -- Varargs (teaches packing/unpacking args)
    
    if not serverCallbacks[name] then
        print('^1[Bridge Error] Callback not registered: ' .. name)
        TriggerClientEvent('rframework:qb:callbackResponse', src, requestId, nil, 'Callback not found')
        return
    end
    
    -- Execute handler (teaches safe call with pcall for errors)
    local success, result = pcall(serverCallbacks[name], src, ...)
    if not success then
        print('^1[Bridge Error] Callback execution failed: ' .. name .. ' - ' .. result)  -- result is error msg
        TriggerClientEvent('rframework:qb:callbackResponse', src, requestId, nil, 'Execution error')
        return
    end
    
    -- Send response (result can be table, string, etc.)
    TriggerClientEvent('rframework:qb:callbackResponse', src, requestId, result)
end)

-- QB-style: TriggerServerCallback (but this is client-called via export; server doesn't trigger to client here)
-- Wait, QB has client TriggerServerCallback— so export for client use
exports('TriggerServerCallback', function(name, cb, ...)
    -- This is server-side? No—QB's TriggerServerCallback is client function.
    -- Bridge confusion: Since bridge is server, we need client wrapper.
    -- For now, assume qb scripts call from client: Add client file if needed.
end)

-- To support client calls, add client/bridge.lua (see Step 3)