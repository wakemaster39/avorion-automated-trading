# Creating a new Window

Creating a new window has a few requirements about what has to exist for it to work below is an example of the bare minimum code

```lua
package.path = package.path .. ";data/config/?.lua"
package.path = package.path .. ";data/scripts/lib/?.lua"

include ("stringutility") -- required for all the %_t at the end of strings
include ("callable") -- required to have a function callable from the client on the server

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

-- required to determine when to display the icon, without this you will never see your new menu to launch it
function TradeManager.interactionPossible(playerIndex)
   local factionIndex = Entity().factionIndex
   if Entity().index.number == Player(playerIndex).craftIndex.number and (factionIndex == playerIndex or factionIndex == Player(playerIndex).allianceIndex) then
       return true
   end
   return false
end

function TradeManager.initUI()
    local res = getResolution()
    local size = vec2(335, 350)

    local menu = ScriptUI()
    local window = menu:createWindow(Rect(res * 0.5 - size * 0.5, res * 0.5 + size * 0.5))

    window.caption = "Trade Manager"%_t
    window.showCloseButton = 1
    window.moveable = 1
    menu:registerWindow(window, "Manage Trade"%_t);
end

--====================
--===== Server =======
--====================
-- config stuff is just an example of how to handle setting a config on a server and loading if up on the client for use
function TradeManager.getConfig()
    local player = Player(callingPlayer)
    invokeClientFunction(player, "receiveConfig", config)
end
callable(TradeManager, "getConfig")
```