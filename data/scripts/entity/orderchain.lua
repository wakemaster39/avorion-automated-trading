function OrderChain.addTradeOrder(persistent)
    if onClient() then
        invokeServerFunction("addTradeOrder", persistent)
        return
    end

    if callingPlayer then
        local owner, _, player = checkEntityInteractionPermissions(Entity(), AlliancePrivilege.ManageShips)
        if not owner then return end
    end
    player:sendChatMessage("", ChatMessageType.Error, "Fuck"%_T)
end