RP = RP or {}
RP.Utils = RP.Utils or {}

function RP.Utils.Debug(msg)
    if Config.EnableDebug then
        print(("[RF-CORE] %s"):format(msg))
    end
end

function RP.Utils.TableDeepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = RP.Utils.TableDeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function RP.Utils.SafeCallback(cb, ...)
    if cb and type(cb) == "function" then
        local ok, err = pcall(cb, ...)
        if not ok then
            RP.Utils.Debug("Callback error: " .. tostring(err))
        end
    end
end
