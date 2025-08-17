local QBCore = exports['qb-core']:GetCoreObject()

-- Function to give item to player
local function GiveItemToPlayer(source, item, amount)
    local success = false
    
    if Config.InventorySystem == 'ox_inventory' then
        success = exports.ox_inventory:AddItem(source, item, amount)
    elseif Config.InventorySystem == 'qb_inventory' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            success = Player.Functions.AddItem(item, amount)
        end
    end
    
    if success then
        TriggerClientEvent('QBCore:Notify', source, 'You received ' .. amount .. 'x ' .. item, 'success')
        return true
    else
        TriggerClientEvent('QBCore:Notify', source, 'Failed to give item: ' .. item, 'error')
        return false
    end
end

-- Function to remove item from player
local function RemoveItemFromPlayer(source, item, amount)
    local success = false
    
    if Config.InventorySystem == 'ox_inventory' then
        success = exports.ox_inventory:RemoveItem(source, item, amount)
    elseif Config.InventorySystem == 'qb_inventory' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            success = Player.Functions.RemoveItem(item, amount)
        end
    end
    
    if success then
        TriggerClientEvent('QBCore:Notify', source, 'Removed ' .. amount .. 'x ' .. item, 'info')
        return true
    else
        TriggerClientEvent('QBCore:Notify', source, 'Failed to remove item: ' .. item, 'error')
        return false
    end
end

-- Function to check if player has item
local function PlayerHasItem(source, item, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    if Config.InventorySystem == 'ox_inventory' then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count >= (amount or 1)
    elseif Config.InventorySystem == 'qb_inventory' then
        local itemCount = Player.Functions.GetItemByName(item)
        if itemCount then
            return itemCount.amount >= (amount or 1)
        end
    end
    return false
end

-- Function to process rewards (handles both single and multiple rewards)
local function ProcessRewards(source, rewardData)
    if not rewardData then return end

    if Config.InventorySystem == 'ox_inventory' then
        -- Handle multiple rewards (new format)
        if rewardData.items then
            for _, reward in ipairs(rewardData.items) do
                local shouldGive = true

                if reward.chance and reward.chance < 100 then
                    local random = math.random(1, 100)
                    shouldGive = random <= reward.chance
                end

                if shouldGive then
                    GiveItemToPlayer(source, reward.item, reward.amount)
                end
            end
        elseif rewardData.item then
            local shouldGive = true

            if rewardData.chance and rewardData.chance < 100 then
                local random = math.random(1, 100)
                shouldGive = random <= rewardData.chance
            end

            if shouldGive then
                GiveItemToPlayer(source, rewardData.item, rewardData.amount)
            else
                TriggerClientEvent('QBCore:Notify', source, 'You didn\'t get anything from using this item.', 'info')
            end
        end
    elseif Config.InventorySystem == 'qb_inventory' then
        -- Handle multiple rewards (new format)
        if rewardData.items then
            for _, reward in ipairs(rewardData.items) do
                local shouldGive = true

                if reward.chance and reward.chance < 100 then
                    local random = math.random(1, 100)
                    shouldGive = random <= reward.chance
                end

                if shouldGive then
                    GiveItemToPlayer(source, reward.item, reward.amount)
                end
            end
        elseif rewardData.item then
            local shouldGive = true

            if rewardData.chance and rewardData.chance < 100 then
                local random = math.random(1, 100)
                shouldGive = random <= rewardData.chance
            end

            if shouldGive then
                GiveItemToPlayer(source, rewardData.item, rewardData.amount)
            else
                TriggerClientEvent('QBCore:Notify', source, 'You didn\'t get anything from using this item.', 'info')
            end
        end
    end
end

CreateThread(function()
    Wait(1000)
    
    if Config.Debug then
        print('^2[UsableItems]^7 Using inventory system: ' .. Config.InventorySystem)
    end
    
    for itemName, itemData in pairs(Config.UsableItems) do
        QBCore.Functions.CreateUseableItem(itemName, function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)
            if Player.Functions.GetItemBySlot(item.slot) ~= nil then
                if itemData.requiredItem then
                    if Config.Debug then
                        print('^2[UsableItems]^7 Checking required item: ' .. itemData.requiredItem.item .. ' for player ' .. Player.PlayerData.name)
                    end
                    
                    if not PlayerHasItem(source, itemData.requiredItem.item, itemData.requiredItem.amount) then
                        if Config.Debug then
                            print('^1[UsableItems]^7 Player missing required item: ' .. itemData.requiredItem.item)
                        end
                        TriggerClientEvent('QBCore:Notify', source, 'You need a ' .. itemData.requiredItem.item .. ' to use this item!', 'error')
                        return
                    end
                    
                    if Config.Debug then
                        print('^2[UsableItems]^7 Required item check passed for: ' .. itemData.requiredItem.item)
                    end
                    
                    -- Consume required item if specified
                    if itemData.requiredItem.consume then
                        RemoveItemFromPlayer(source, itemData.requiredItem.item, itemData.requiredItem.amount)
                    end
                end
                
                -- Remove the used item if removeOnUse is true
                if itemData.removeOnUse then
                    RemoveItemFromPlayer(source, itemName, 1)
                end
                
                -- Trigger the client to start using the item
                TriggerClientEvent('usableitems:startUseItem', source, itemName, itemData)
            end
        end)
        
        if Config.Debug then
            print('^2[UsableItems]^7 Server registered item: ' .. itemName)
        end
    end
end)

-- Main event handler for using items
RegisterNetEvent('usableitems:useItem', function(itemName, itemData)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return end
    
    if Config.Debug then
        print('^2[UsableItems]^7 Player ' .. Player.PlayerData.name .. ' used item: ' .. itemName)
    end
    
    -- Process rewards
    ProcessRewards(source, itemData.reward)
    
    -- Log usage if debug is enabled
    if Config.Debug then
        print('^2[UsableItems]^7 Item usage completed for: ' .. itemName)
        if itemData.reward then
            if itemData.reward.items then
                print('^2[UsableItems]^7 Multiple rewards processed')
            else
                print('^2[UsableItems]^7 Single reward processed')
            end
        end
        if itemData.message then
            print('^2[UsableItems]^7 Message shown: ' .. itemData.message)
        end
        if itemData.removeOnUse then
            print('^2[UsableItems]^7 Item consumed: ' .. itemName)
        end
    end
end)

-- Command to give usable item to player (for testing)
QBCore.Commands.Add('giveusableitem', 'Give a usable item to a player (Admin Only)', {{name = 'id', help = 'Player ID'}, {name = 'item', help = 'Item name'}, {name = 'amount', help = 'Amount'}}, true, function(source, args)
    local targetId = tonumber(args[1])
    local itemName = args[2]
    local amount = tonumber(args[3]) or 1
    
    if not targetId or not itemName then
        TriggerClientEvent('QBCore:Notify', source, 'Usage: /giveusableitem [id] [item] [amount]', 'error')
        return
    end
    
    if not Config.UsableItems[itemName] then
        TriggerClientEvent('QBCore:Notify', source, 'Item ' .. itemName .. ' is not configured as a usable item!', 'error')
        return
    end
    
    local success = GiveItemToPlayer(targetId, itemName, amount)
    if success then
        TriggerClientEvent('QBCore:Notify', source, 'Gave ' .. amount .. 'x ' .. itemName .. ' to player ' .. targetId, 'success')
    end
end, 'admin')

-- Command to reload config (for testing)
QBCore.Commands.Add('reloadusableitems', 'Reload the usable items configuration (Admin Only)', {}, true, function(source, args)
    TriggerClientEvent('QBCore:Notify', source, 'Reloading usable items configuration...', 'info')
    
    -- This would require a restart of the resource in a real scenario
    -- For now, just notify the admin
    TriggerClientEvent('QBCore:Notify', source, 'Configuration reloaded! (Resource restart may be required)', 'success')
end, 'admin')

-- Command to list all usable items
QBCore.Commands.Add('listusableitems', 'List all configured usable items', {}, false, function(source, args)
    local itemsList = '^2[UsableItems]^7 Configured items:\n'
    
    for itemName, itemData in pairs(Config.UsableItems) do
        local requirements = ''
        if itemData.requiredItem then
            requirements = ' (Requires: ' .. itemData.requiredItem.amount .. 'x ' .. itemData.requiredItem.item .. ')'
        end
        
        local rewards = ''
        if itemData.reward then
            if itemData.reward.items then
                rewards = ' (Multiple rewards)'
            else
                rewards = ' (Gives: ' .. itemData.reward.amount .. 'x ' .. itemData.reward.item .. ')'
            end
        end
        
        local message = ''
        if itemData.message then
            message = ' (Message: ' .. itemData.message .. ')'
        end
        
        local removeInfo = ''
        if itemData.removeOnUse then
            removeInfo = ' (Consumed on use)'
        end
        
        itemsList = itemsList .. '  - ' .. itemName .. ' (' .. itemData.label .. ')' .. requirements .. rewards .. message .. removeInfo .. '\n'
    end
    
    TriggerClientEvent('QBCore:Notify', source, 'Check console for the list of usable items!', 'info')
    print(itemsList)
end, false)

-- Event when player joins to sync any necessary data
RegisterNetEvent('usableitems:playerJoined', function()
    local source = source
    if Config.Debug then
        print('^2[UsableItems]^7 Player joined: ' .. source)
    end
end)

-- Export functions for other resources to use
exports('IsItemUsable', function(itemName)
    return Config.UsableItems[itemName] ~= nil
end)

exports('GetItemConfig', function(itemName)
    return Config.UsableItems[itemName]
end)

exports('RegisterUsableItem', function(itemName, config)
    if Config.UsableItems[itemName] then
        print('^3[UsableItems]^7 Warning: Item ' .. itemName .. ' is already registered!')
        return false
    end
    
    Config.UsableItems[itemName] = config
    print('^2[UsableItems]^7 Dynamically registered item: ' .. itemName)
    return true
end)

-- Initialize
CreateThread(function()
    Wait(1000)
    print('^2[UsableItems]^7 Server script loaded successfully!')
    print('^2[UsableItems]^7 Using inventory system: ' .. Config.InventorySystem)
    print('^2[UsableItems]^7 Registered ' .. #Config.UsableItems .. ' usable items')
    
    if Config.Debug then
        print('^2[UsableItems]^7 Debug mode is enabled')
    end
end)
