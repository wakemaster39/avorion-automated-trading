
DebuggingUtils = {}

if onServer() then
function DebuggingUtils.error_logger(err)
    if callingPlayer then
        Player(callingPlayer):sendChatMessage()
        player:sendChatMessage("", 1, "calling_player"%_t)
        player:sendChatMessage("", 1, err)
        return
    end
    Sever():broadcastChatMessage("", 1, "no_calling_player")
    Sever():broadcastChatMessage("", 1, err)
    return
end
end

if onClient() then
function DebuggingUtils.error_logger(err)
    local player = Player()
    if player then
        player:sendChatMessage(err)
    end
end
end

function DebuggingUtils.pcall(...)


end

function DebuggingUtils.table_to_print_string(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        -- Check the key type (ignore any numerical keys - assume its an array)
        if type(k) == "string" then
            result = result.."[\""..k.."\"]".."="
        end

        -- Check the value type
        if type(v) == "table" then
            result = result..table_to_string(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result.."\""..v.."\""
        end
        result = result..","
    end
    -- Remove leading commas from the result
    if result ~= "{" then
        result = result:sub(1, result:len()-1)
    end
    return result.."}"
end