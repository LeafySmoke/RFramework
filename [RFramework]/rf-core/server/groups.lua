RFramework.Groups = {
    admin = {perms = {'kick', 'ban'}},
    mod = {perms = {'warn'}}
}

function RFramework.HasGroupPermission(src, group, perm)
    if IsPlayerAceAllowed(src, group) then
        local groupData = RFramework.Groups[group]
        return groupData and table.contains(groupData.perms, perm)
    end
    return false
end