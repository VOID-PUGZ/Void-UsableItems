local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local isUsingItem = false

-- Initialize player data
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

-- Function to show notification
local function ShowNotification(message, type)
    QBCore.Functions.Notify(message, type, Config.Notifications[type].duration)
end

-- Main function to use item
local function UseItem(itemName, itemData)
    if isUsingItem then
        ShowNotification('You are already using an item!', 'error')
        return
    end
    
    -- Start using item
    isUsingItem = true
    
    -- Show progress bar with animation
    if lib.progressBar({
        duration = itemData.useTime or Config.DefaultUseTime,
        label = 'Using ' .. itemData.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = itemData.animation and itemData.animation.dict or nil,
            clip = itemData.animation and itemData.animation.anim or nil,
            flag = itemData.animation and itemData.animation.flag or 49
        }
    }) then
        -- Progress bar completed successfully
        TriggerServerEvent('usableitems:useItem', itemName, itemData)
        
        -- Show success message
        if itemData.message then
            ShowNotification(itemData.message, 'success')
        else
            ShowNotification('Successfully used ' .. itemData.label .. '!', 'success')
        end
    else
        -- Progress bar was cancelled
        ShowNotification('Cancelled using ' .. itemData.label, 'info')
    end
    
    isUsingItem = false
end

-- Event handler for when server triggers item usage
RegisterNetEvent('usableitems:startUseItem', function(itemName, itemData)
    UseItem(itemName, itemData)
end)

-- Debug command
if Config.Debug then
    RegisterCommand('usableitems_debug', function()
        print('^2[UsableItems Debug]^7')
        print('Registered Items:')
        for itemName, itemData in pairs(Config.UsableItems) do
            print('  - ' .. itemName .. ' (' .. itemData.label .. ')')
        end
    end, false)
end
