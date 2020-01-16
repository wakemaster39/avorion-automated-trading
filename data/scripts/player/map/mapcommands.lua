include("data/scripts/lib/utils/enum")

EnumUtils.addNextKey(OrderButtonType, "Trade")

if onClient() then

local autotrade_initUI = MapCommands.initUI

function MapCommands.initUI()
    autotrade_initUI()

    local order = {tooltip = "Trade"%_t,              icon = "data/textures/icons/battery-pack.png",              callback = "onTradePressed",         type = OrderButtonType.Trade}
    table.insert(orders, order)

    local button = ordersContainer:createRoundButton(Rect(), order.icon, order.callback)
    button.tooltip = order.tooltip

    table.insert(orderButtons, button)
end


function MapCommands.onTradePressed()
    local player = Player()
    player:sendChatMessage("Fuck you")
    --MapCommands.clearOrdersIfNecessary()
    --MapCommands.enqueueOrder("addTradeOrder")
end

end 