RFramework = {}
QBCore = exports['rframework']:GetSharedObject()

function RFramework.Notify(src, msg, type)
    TriggerClientEvent('ox_lib:notify', src, {type = type or 'info', description = msg})
end

exports('GetCoreObject', function() return RFramework end)

function generateRequestId()
    return 'cb_' .. math.random(100000, 999999) .. '_' .. GetGameTimer()
end