package.path = package.path .. ";data/scripts/lib/?.lua"

local config = include("data/config/trade_manager_config")

if config.debug then

function execute(playerIndex, commandName)

    local player = Player(playerIndex)
    broadcastInvokeClientFunction("reloadTradeManager")

    return 0, "executed", ""
end

function getDescription()
    return "Reload trade manager script, making it easier to debug the script"
end

function getHelp()
    return "Reload trade manager script, making it easier to debug the script. Usage: /reload"
end

end