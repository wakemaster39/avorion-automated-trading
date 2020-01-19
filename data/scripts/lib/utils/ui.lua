package.path = package.path .. ";data/config/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"

include ("stringutility")
include ("callable")

local config = include("data/config/trade_manager_config")

--namespace UIUtils
UIUtils = {}

function UIUtils.getWrapperSendKey(storageKey)
    prefix = prefix or ""
    return "send"..storageKey
end

function UIUtils.storeGetValueWrapper(namespace, storageKey, receiveFunction, prefix)
    if onServer() then
        prefix = prefix or ""

        local function sendValue()
            local player = Player(callingPlayer)
            if not player then
                if config.debug then
                    print("No calling user when asked for value", storageKey, prefix)
                end
                return 
            end
            local value = TableUtils.deserialize(player:getValue(prefix..storageKey))
            invokeClientFunction(player, "receive"..storageKey, value)
        end
        namespace["send"..storageKey] = sendValue
        callable(TradeManager, "send"..storageKey)

        local function setValue(value)
            local player = Player(callingPlayer)
            serializedValue = TableUtils.serialize(value or {})
            player:setValue(prefix..storageKey, serializedValue)
        end
        namespace["set"..storageKey] = setValue
        callable(namespace, "set"..storageKey)
    else
        namespace["receive"..storageKey] = receiveFunction
    end
end

--- Returns X coordinates for object around the centre of a UIElement
-- @param parent UIElement to centre around
-- @param size Size of the child element to find the centre for
function UIUtils.centerUIElementX(parent, size)
    return parent.size.x/2 - size, parent.size.x/2 + size
end
