package.path = package.path .. ";data/config/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"

include ("stringutility")
include ("callable")
include ("data/scripts/lib/utils/table")
include ("data/scripts/entity/trade_manager")
include ("data/scripts/lib/utils/ui")

local config = include("data/config/trade_manager_config")


-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace TradeManager
TradeManager = {}

local goodsListsStorageString = "TradeManagerGoodsLists"

if onClient() then
    local goodsStatusLabel, goodsListsScrollframe
    local addGoodsListsButton
    local goodsLists = {}
    local goodsListsLines = {}
    local lineElementToIndex = {}


    function TradeManager.initialize()
        local player = Player()
        -- player:registerCallback("onSelectMapCoordinates", "onSelectMapCoordinates")
        invokeServerFunction("getConfig")
    end

    function TradeManager.receiveConfig(rConfig)
        config = rConfig
    end

    function TradeManager.getIcon()
        return "data/textures/icons/battery-pack.png"
    end

    function TradeManager.interactionPossible(playerIndex)
        local factionIndex = Entity().factionIndex
        if Entity().index.number == Player(playerIndex).craftIndex.number and (factionIndex == playerIndex or factionIndex == Player(playerIndex).allianceIndex) then
            return true
        end
        return false
    end

    local window
    function TradeManager.initUI()
        local res = getResolution()
        local size = vec2(500, 350)
        
        local menu = ScriptUI()
        window = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))

        window.caption = "Trade Manager"%_t
        window.showCloseButton = 1
        window.moveable = 1
        menu:registerWindow(window, "Manage Trade"%_t);

        local tabbedWindow = window:createTabbedWindow(Rect(vec2(10, 10), size - 10))

        -- create tab
        local goodListTab = tabbedWindow:createTab("Goods Lists", "", "List of goods usable for creating rules")

        -- create tab
        local buyRuleTab = tabbedWindow:createTab("Buy Rules", "", "List of rule sets for buying goods")
        local sellRuleTab = tabbedWindow:createTab("Sell Rules", "", "List of rule sets for selling goods")

        TradeManager.init_goods_list_tab(goodListTab)
        invokeServerFunction("setGoodsLists", {q="f"})
    end

    function TradeManager.init_goods_list_tab(tab)
        goodsStatusLabel = tab:createLabel(vec2(tab.size.x - 85, 0), "?/?", 12)
        goodsStatusLabel.width = 80
        goodsStatusLabel:setRightAligned()
        local textLabel = tab:createLabel(vec2(5, 0), "Goods Lists:"%_t, 12)
        textLabel.tooltip = "Shows the number of Goods List that can be stored and are being stored."%_t
        textLabel:setLeftAligned()
    
        goodsListsScrollframe = tab:createScrollFrame(Rect(vec2(0, 35), tab.size - vec2(0,0)))
        goodsListsScrollframe.scrollSpeed = 35


        local y = 35
        local buttonSize = vec2(80,25)
        local bPX = vec2(UIUtils.centerUIElementX(goodsListsScrollframe, buttonSize.x))
        local buttonRect = Rect(bPX.x-10, y+5, bPX.y-10, y+5+buttonSize.y)
        addGoodsListsButton = goodsListsScrollframe:createButton(buttonRect, "Add", "onAddGoodsListsButtonPressed")
        addGoodsListsButton.active = true
        addGoodsListsButton.tooltip = "Add a new list of goods to be managed."%_t  
    end

    function TradeManager.onShowWindow()
        invokeServerFunction(UIUtils.getWrapperSendKey("GoodsLists"))
    end

    function TradeManager.onAddGoodsListsButtonPressed()
        local inputWindow = window:createInputWindow()
        inputWindow.caption = "Goods List Entry"
        inputWindow.onOKFunction = "onAddGoodsListNameOk"
        inputWindow:show("Enter the name of the Goods List")
    end

    function TradeManager.onAddGoodsListNameOk(inputWindow, name)
        inputWindow:hide()
        displayChatMessage("FUCK", "Trade Manager"%_t, 0)

        goodsLists[#goodsLists + 1] = { name=name, goods={}}
        TradeManager.appendGoodsListsLine(name)
        -- invokeServerFunction("setGoodsLists", goodsLists)
    end

    function TradeManager.appendGoodsListsLine(name)
        print(#goodsListsLines)
        print(TableUtils.serialize(goodsListsLines))
        local index = #goodsListsLines + 1
        local y = index * 35
        local labelsize = vec2(130, 35)
        local buttonSize = vec2(32, 32)
        local bX = {200, 240, 280}

        local labelText = name
        local sectorLabel = goodsListsScrollframe:createLabel(vec2(5,y), labelText, 12)
        sectorLabel.width = labelsize.x
        sectorLabel.height = labelsize.y
--        sectorLabel.mouseDownFunction = "sectorLabelPressed"
        sectorLabel.tooltip = "Click to show the sector on the Galaxymap."%_t
        lineElementToIndex[sectorLabel.index] = index

        addGoodsListsButton.position = addGoodsListsButton.position + vec2(0,35)

        goodsListsLines[index] = {}
    end
else
    --====================
    --===== Server =======
    --====================
    function TradeManager.getConfig()
        local player = Player(callingPlayer)
        invokeClientFunction(player, "receiveConfig", config)
    end
    callable(TradeManager, "getConfig")

end

local function receiveGoodsList(goodsList)
    print("FUCKV")
end
UIUtils.storeGetValueWrapper(TradeManager, "GoodsLists", receiveGoodsList, "TradeManager")
print(TableUtils.serialize(TradeManager))
