package.path = package.path .. ";data/config/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"

include ("stringutility")
include ("utility")
include("callable")
-- include("data/scripts/lib/utils/table")

local config = include("data/config/trade_manager_config")
local lib = include("data/scripts/lib/sectorManagerLib")

-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace TradeManager
TradeManager = {}

local uiInitialized = false
local scrollframe
local addButton, selectSectorButton
local sectorStatusLabel

function TradeManager.initialize()
    if onClient() then
        invokeServerFunction("getConfig")
    end
end

function TradeManager.receiveConfig(rConfig)
    config = rConfig
end

function TradeManager.getIcon()
    print("You fucked up6")
    return "data/textures/icons/battery-pack.png"
end

function TradeManager.initUI()
    local res = getResolution()
    local size = vec2(335, 350)

    local menu = ScriptUI()
    local window = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))


    sectorStatusLabel = window:createLabel(vec2(window.size.x - 85, 0), "?/?", 12)
    sectorStatusLabel.width = 80
    sectorStatusLabel:setRightAligned()
    local textLabel = window:createLabel(vec2(5, 0), "Sectors:"%_t, 12)
    textLabel.tooltip = "Shows the number of Sectors you want to load and the maximum allowed loaded sectors."%_t
    textLabel:setLeftAligned()

    scrollframe = window:createScrollFrame(Rect(vec2(0, 35), window.size - vec2(0,0)))
    scrollframe.scrollSpeed = 35

    local y = 35
    local buttonSize = vec2(80,25)
    local bPX = vec2(lib.centerUIElementX(scrollframe, buttonSize.x))
    local buttonRect = Rect(bPX.x-10, y+5, bPX.y-10, y+5+buttonSize.y)
    addButton = scrollframe:createButton(buttonRect, "Add", "onAddButtonPressed")
    addButton.active = false
    addButton.tooltip = "Select a sector on the Galaxymap."%_t
    y = y + 35

    buttonSize = vec2(150,25)
    bPX = vec2(lib.centerUIElementX(scrollframe, buttonSize.x))
    buttonRect = Rect(bPX.x-10, y+5, bPX.y-10, y+5+buttonSize.y)
    selectSectorButton = scrollframe:createButton(buttonRect, "Select Sector", "onSelectSectorButtonPressed")

    print(window)
    uiInitialized = true
end

function TradeManager.onShowWindow()
    print("show window")
end

function TradeManager.onCloseWindow()
    print("close window")
end

function TradeManager.onAddButtonPressed()
    print("Add button presses")
end

function TradeManager.onSelectSectorButtonPressed()
    print("Select Sector button presses")
end

--====================
--===== Server =======
--====================
function TradeManager.getConfig()
    local player = Player(callingPlayer)
    invokeClientFunction(player, "receiveConfig", config)
end
callable(TradeManager, "getConfig")