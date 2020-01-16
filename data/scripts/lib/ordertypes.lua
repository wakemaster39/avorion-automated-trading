OrderType["AutomatedTrade"] = OrderType["NumActions"]
OrderType["NumActions"] = OrderType["NumActions"] + 1

OrderTypes[OrderType.AutomatedTrade] = {
    name = "Trade+ /* short order summary */"%_t,
    icon = "data/textures/icons/battery-pack.png",
    pixelIcon = "data/textures/icons/battery-pack.png",
}