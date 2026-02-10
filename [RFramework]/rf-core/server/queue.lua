local queue = {}
local maxPlayers = 32

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    deferrals.update('Checking queue...')
    if #queue >= maxPlayers then
        table.insert(queue, src)
        deferrals.update('In queue: Position ' .. #queue)
        while #queue > 0 and queue[1] ~= src do Citizen.Wait(1000) end
        table.remove(queue, 1)
    end
    deferrals.done()
end)