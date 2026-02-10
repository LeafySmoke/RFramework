-- RFramework NUI (UI) Management

local nuiReady = false

-- Send NUI message
RFramework.SendNUIMessage = function(data)
    SendNUIMessage(data)
end

-- Show/Hide UI
RFramework.ToggleUI = function(show)
    RFramework.SendNUIMessage({
        action = 'toggle',
        show = show
    })
    SetNuiFocus(show, show)
end

-- Update HUD
RFramework.UpdateHUD = function(data)
    RFramework.SendNUIMessage({
        action = 'updateHUD',
        data = data
    })
end

-- NUI Callback handler
RegisterNUICallback('ready', function(data, cb)
    nuiReady = true
    cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
    RFramework.ToggleUI(false)
    cb('ok')
end)

-- Update HUD when player data changes
AddEventHandler('rframework:onPlayerLoaded', function(playerData)
    if Config.UI.ShowPlayerHUD then
        RFramework.UpdateHUD({
            money = playerData.money,
            bank = playerData.bank,
            job = playerData.job.label,
            jobGrade = playerData.job.grade_label
        })
    end
end)

AddEventHandler('rframework:onMoneyChange', function(account, amount)
    if Config.UI.ShowPlayerHUD then
        local playerData = RFramework.GetPlayerData()
        if playerData then
            RFramework.UpdateHUD({
                money = playerData.money,
                bank = playerData.bank,
                job = playerData.job.label,
                jobGrade = playerData.job.grade_label
            })
        end
    end
end)

AddEventHandler('rframework:onJobChange', function(job)
    if Config.UI.ShowPlayerHUD then
        local playerData = RFramework.GetPlayerData()
        if playerData then
            RFramework.UpdateHUD({
                money = playerData.money,
                bank = playerData.bank,
                job = job.label,
                jobGrade = job.grade_label
            })
        end
    end
end)

-- Toggle UI command (for debugging)
RegisterCommand('toggleui', function()
    local playerData = RFramework.GetPlayerData()
    if playerData then
        RFramework.ToggleUI(true)
    end
end, false)
