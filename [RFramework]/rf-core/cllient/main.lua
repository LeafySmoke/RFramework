local RFramework = exports['rframework']:GetCoreObject()

AddEventHandler('playerSpawned', function()
    lib.progressBar({duration = 3000, label = 'Loading Character...'})
    SetEntityCoords(PlayerPedId(), Config.Spawn.xyz)
    SetEntityHeading(PlayerPedId(), Config.Spawn.w)
end)

RegisterNetEvent('rframework:client:setJob', function(job)
    RFramework.Notify(-1, 'Job set to ' .. job)
end)

exports.ox_target:addModel(`a_m_y_business_01`, {
    { name = 'talk', label = 'Talk to NPC', icon = 'fas fa-comment', onSelect = function() print('Talking!') end }
})