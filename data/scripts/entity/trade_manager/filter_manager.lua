package.path = package.path .. ";data/config/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"

include ("stringutility")
include ("callable")
include ("data/scripts/lib/utils/table")
include ("data/scripts/entity/trade_manager")

local config = include("data/config/trade_manager_config")


-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace TradeManager
TradeManager = {}


function TradeManager.initialize()
    if onClient() then
        local player = Player()
        -- player:registerCallback("onSelectMapCoordinates", "onSelectMapCoordinates")
        invokeServerFunction("getConfig")
    end
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

local goodsComboBoxes = {}

function TradeManager.initUI()
    TradeManager.init_filter_manager()

    local res = getResolution()
    local size = vec2(900, 600)

    local menu = ScriptUI()
    local window = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))

    window.caption = "Trade Manager55"%_t
    window.showCloseButton = 1
    window.moveable = 1
    menu:registerWindow(window, "Manage Trade55"%_t);

    -- Top Window Controls
    local topRect = Rect(10, 10, window.width - 10, 35)
    local toggleSplitter = UIVerticalSplitter(topRect, 10, 0, 0.13)
    local leftRowsSplitter = UIVerticalSplitter(toggleSplitter.right, 10, 0, 0.17)
    local topButtonsSplitter = UIVerticalMultiSplitter(leftRowsSplitter.right, 10, 0, 4)

    print(TableUtils.serialize(config))

    toggleCheckBox = window:createCheckBox(Rect(toggleSplitter.left.lower + vec2(0, 2.5), toggleSplitter.left.upper + vec2(0, -2.5)), "Toggle", "")
    leftRowsLabel = window:createLabel(Rect(leftRowsSplitter.left.lower + vec2(0, 5), leftRowsSplitter.left.upper), string.format("0/%u rows used", config.maxRows), 15) 
    local clearAllButton = window:createButton(topButtonsSplitter:partition(0), "Clear all", "onClearAllButtonClicked")
    local resetButton = window:createButton(topButtonsSplitter:partition(1), "Reset", "onResetButtonClicked")
    local addRowStartButton = window:createButton(topButtonsSplitter:partition(2), "+ Row start", "onAddRowStartButtonClicked")
    local addRowEndButton = window:createButton(topButtonsSplitter:partition(3), "+ Row end", "onAddRowEndButtonClicked")
    window:createButton(topButtonsSplitter:partition(4), "", "onApplyButtonClicked")
    local applyLabelPartition = topButtonsSplitter:partition(4)
    applyLabel = window:createLabel(Rect(applyLabelPartition.lower + vec2(0, 4), applyLabelPartition.upper), "Apply", 14)

    toggleCheckBox.captionLeft = false
    leftRowsLabel.centered = true
    clearAllButton.textSize = 14
    resetButton.textSize = 14
    addRowStartButton.textSize = 14
    addRowEndButton.textSize = 14
    applyLabel.centered = true

    -- Main Body Controls
    local frame = window:createScrollFrame(Rect(vec2(10, 45), window.size - vec2(10, 10)))
    local lister = UIVerticalLister(Rect(vec2(10, 10), window.size - vec2(80, 10)), 10, 0)
    local rect, targetSplitter, targetArgSplitter, notSplitter, conditionSplitter, conditionArgSplitter
    local goodsComboBox, targetArgComboBox, targetArgTextBox, notComboBox, conditionComboBox, conditionArgComboBox, conditionArgTextBox, operatorComboBox
    local rowLine, connectorLine, separatorLine

    -- for i, config.maxRows do
    --     rect = lister:placeRight(vec2(lister.inner.width - 30, 25))
    --     goodsSplitter = UIVerticalSplitter(rect, 10, 0, 0.26)
    --     goodsArgSplitter = UIVerticalSplitter(targetSplitter.right, 10, 0, 0.18)
    --     notSplitter = UIVerticalSplitter(targetArgSplitter.right, 10, 0, 0.135)
    --     conditionSplitter = UIVerticalSplitter(notSplitter.right, 10, 0, 0.51)
    --     conditionArgSplitter = UIVerticalSplitter(conditionSplitter.right, 10, 0, 0.54)

    --     insertRowButton = frame:createButton(Rect(rect.upper + vec2(10, -5), rect.upper + vec2(30, 15)), "+", "OnInsertRowButtonClicked")
    --     rowLine = frame:createLine(rect.lower + vec2(-30, 12.5), rect.lower + vec2(-10, 12.5))
    --     connectorLine = frame:createLine(rect.lower + vec2(-30, 12.5), rect.lower + vec2(-30, 47.5))
    --     separatorLine = frame:createLine(rect.lower + vec2(-30, 30), rect.upper + vec2(0, 5))

    --     goodsComboBox = frame:createComboBox(goodsSplitter.left, "onGoodsBoxSelected")

    --     goodsComboBox.visible = false
    --     -- goodsArgComboBox.visible = false
    --     -- ArgTextBox.visible = false
    --     -- notComboBox.visible = false
    --     -- conditionComboBox.visible = false
    --     -- conditionArgComboBox.visible = false
    --     -- conditionArgTextBox.visible = false
    --     -- operatorComboBox.visible = false
    --     insertRowButton.visible = false
    --     rowLine.visible = false
    --     connectorLine.visible = false
    --     separatorLine.visible = false

    --     goodsComboBoxes[i] = goodsComboBox
    -- end

    -- rect = lister:placeRight(vec2(1, 1))
    -- emptySpace = frame:createLine(rect.lower, rect.upper)
    -- emptySpace.color = ColorInt(0x00000000)
end


local filter_manager_window, filter_editor_window
function TradeManager.init_filter_manager()
    local res = getResolution()
    local size = vec2(335, 350)
    
    local menu = ScriptUI()
    local window = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))

    window.caption = "Trade Filter Manager"%_t
    window.showCloseButton = 1
    window.moveable = 1
    menu:registerWindow(window, "Manage Trade2"%_t);
end

function TradeManager.onAddRowStartButtonClicked()
    if not isSettingsLoaded then return end
    if rowsUsed == config.maxRows then
        Player():sendChatMessage("There are no empty rows left"%_t)
        return
    end
    local data = ComplexCraftOrders.serializeRules()
    table.insert(data.rules, 1, {
      target = targetsSorted[1],
      invert = 0,
      condition = conditionsSorted[1],
      operator = ConditionOperator.And
    })
    ComplexCraftOrders.clear()
    ComplexCraftOrders.deserializeRules(ComplexCraftOrders.fixRules(data))
end

function TradeManager.OnInsertRowButtonClicked(button)
    if rowsUsed == config.maxRows then
        Player():sendChatMessage("There are no empty rows left"%_t)
        return
    end
    local rowIndex = rowByInsertRowButton[button.index]
    local data = ComplexCraftOrders.serializeRules()
    local operator = operatorComboBoxes[rowIndex].selectedIndex
    local isCondition = notComboBoxes[rowIndex].visible

    if (isCondition and operator ~= ConditionOperator.Action) or (not isCondition and operator == ActionOperator.None) then
        table.insert(data.rules, rowIndex+1, {
          target = targetsSorted[1],
          invert = 0,
          condition = conditionsSorted[1],
          operator = ConditionOperator.And
        })
    else -- insert Action with 'and' operator
        table.insert(data.rules, rowIndex+1, {
          action = actionsSorted[1],
          operator = ActionOperator.And
        })
    end
    
    ComplexCraftOrders.clear()
    ComplexCraftOrders.deserializeRules(ComplexCraftOrders.fixRules(data))
end

function TradeManager.onGoodsBoxSelected(box, selectedIndex, arg)
    if box.selectedEntry == "" then return end -- it's empty target for 'Action' rows
    local rowIndex = rowByTargetComboBox[box.index]
    local target = targetsSorted[selectedIndex+1]
    if box.selectedEntry == "- Remove row" then
        ComplexCraftOrders.removeRow(rowIndex)
        return
    end
    if targetComboBoxesOldValue[rowIndex] == selectedIndex then return end
    targetComboBoxesOldValue[rowIndex] = selectedIndex
    
    local targetArgTextBox = targetArgTextBoxes[rowIndex]
    local targetArgComboBox = targetArgComboBoxes[rowIndex]
    targetArgTextBox.visible = false
    targetArgComboBox.visible = false
    
    local argData = targets[target].argument
    if argData then
        if type(argData) ~= "table" then
            targetArgComboBox.visible = false
            targetArgTextBox.text = arg and tostring(arg) or ""
            targetArgTextBox.visible = true
        else
            targetArgTextBox.visible = false
            targetArgComboBox:clear()
            for i = 1, #argData do
                targetArgComboBox:addEntry(argData[i])
            end
            if arg and tonumber(arg) > 0 then
                targetArgComboBox.selectedIndex = tonumber(arg)-1
            end
            targetArgComboBox.visible = true
        end
    end
    
    isUnsaved = true
    applyLabel.color = ColorInt(0xffffff4d)
end

--====================
--===== Server =======
--====================
function TradeManager.getConfig()
    local player = Player(callingPlayer)
    invokeClientFunction(player, "receiveConfig", config)
end
callable(TradeManager, "getConfig")
