-- Client-side QB global (shared with server via exports)
QBCore = exports['rframework']:GetSharedObject()  -- If not already in shared

-- Pending callbacks (table: requestId -> cb func)
local clientCallbacks = {}

-- QB-style: TriggerServerCallback (client asks server)
QBCore.Functions.TriggerServerCallback = function(name, cb, ...)
    if type(name) ~= 'string' or type(cb) ~= 'function' then
        print('[Bridge Error] Invalid TriggerServerCallback: ' .. name)
        return
    end
    
    local requestId = generateRequestId()  -- Reuse generator (add to shared.lua)
    clientCallbacks[requestId] = cb
    
    -- Trigger server (teaches packing args)
    TriggerServerEvent('rframework:qb:triggerServerCallback', name, requestId, ...)
end

-- Response event from server
RegisterNetEvent('rframework:qb:callbackResponse', function(requestId, result, errorMsg)
    local cb = clientCallbacks[requestId]
    if not cb then return end  -- Expired or invalid
    
    if errorMsg then
        print('[Bridge Error] Callback response: ' .. errorMsg)
    else
        cb(result)  -- Call with data (teaches invocation)
    end
    
    clientCallbacks[requestId] = nil  -- Cleanup (prevents memory leak)
end)

-- Shared ID generator (move to shared.lua if needed)
function generateRequestId()
    return 'cb_' .. math.random(100000, 999999) .. '_' .. GetGameTimer()
end