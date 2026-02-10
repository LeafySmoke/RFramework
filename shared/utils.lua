-- Shared utility functions for RFramework

RFramework = {}
RFramework.Utils = {}

-- Round a number to specified decimal places
function RFramework.Utils.Round(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10 ^ numDecimalPlaces
        return math.floor((value * power) + 0.5) / power
    else
        return math.floor(value + 0.5)
    end
end

-- Format money value
function RFramework.Utils.FormatMoney(value)
    value = tostring(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

-- Get distance between two coords
function RFramework.Utils.GetDistance(coords1, coords2)
    local x1, y1, z1 = table.unpack(coords1)
    local x2, y2, z2 = table.unpack(coords2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

-- Table functions
function RFramework.Utils.TableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function RFramework.Utils.TableCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[RFramework.Utils.TableCopy(orig_key)] = RFramework.Utils.TableCopy(orig_value)
        end
        setmetatable(copy, RFramework.Utils.TableCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- String functions
function RFramework.Utils.Trim(s)
    return s:match'^%s*(.*%S)' or ''
end

function RFramework.Utils.StartsWith(str, start)
    return str:sub(1, #start) == start
end

function RFramework.Utils.EndsWith(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

-- Debug print
function RFramework.Utils.DebugPrint(...)
    if Config.Framework.Debug then
        print('[RFramework Debug]', ...)
    end
end

-- Server callback system (shared between client and server)
RFramework.ServerCallbacks = {}

if IsDuplicityVersion() then
    -- Server-side
    RFramework.RegisterServerCallback = function(name, cb)
        RFramework.ServerCallbacks[name] = cb
    end

    RegisterNetEvent('rframework:triggerServerCallback')
    AddEventHandler('rframework:triggerServerCallback', function(name, requestId, ...)
        local source = source
        
        if RFramework.ServerCallbacks[name] then
            RFramework.ServerCallbacks[name](source, function(...)
                TriggerClientEvent('rframework:serverCallback', source, requestId, ...)
            end, ...)
        else
            print('[RFramework] Server callback not found: ' .. name)
        end
    end)
else
    -- Client-side
    local serverCallbacks = {}
    local callbackRequestId = 0

    RFramework.TriggerServerCallback = function(name, cb, ...)
        serverCallbacks[callbackRequestId] = cb
        TriggerServerEvent('rframework:triggerServerCallback', name, callbackRequestId, ...)
        callbackRequestId = callbackRequestId + 1
        if callbackRequestId >= 999999 then
            callbackRequestId = 0
        end
    end

    RegisterNetEvent('rframework:serverCallback')
    AddEventHandler('rframework:serverCallback', function(requestId, ...)
        if serverCallbacks[requestId] then
            serverCallbacks[requestId](...)
            serverCallbacks[requestId] = nil
        end
    end)
end
