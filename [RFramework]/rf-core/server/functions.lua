RFramework.Functions = {}

function RFramework.Functions.GetPlayerByLicense(license)
    for src, Player in pairs(RFramework.Players) do
        if Player.PlayerData.license == license then
            return Player
        end
    end
    return nil
end

function RFramework.Functions.GetDistance(pos1, pos2)
    return #(pos1 - pos2)
end

function table.contains(tbl, val)
    for _, v in ipairs(tbl) do if v == val then return true end end
    return false
end

exports('GetPlayerByLicense', RFramework.Functions.GetPlayerByLicense)
exports('GetDistance', RFramework.Functions.GetDistance)