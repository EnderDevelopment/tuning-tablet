local ESX = exports['es_extended']:getSharedObject()

local tabletModel = Config.UI.tabletModel
local tabletProp = nil
local tabletObject = nil
local inRange = false
local currentVehicle = nil
local currentPreset = 'normal'

-- Function to create tablet prop
local function createTabletProp()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local tabletProp = CreateObject(GetHashKey(tabletModel), playerCoords.x, playerCoords.y, playerCoords.z, true, false, true)
    AttachEntityToEntity(tabletProp, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    return tabletProp
end

-- Function to check if player has USB dongle
local function hasDongle()
    if not Config.RequireDongle then return true end
    local xPlayer = ESX.GetPlayerData()
    for _, item in pairs(xPlayer.inventory) do
        if item.name == 'usb_dongle' then
            return true
        end
    end
    return false
end

-- Function to check range
local function checkRange()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(playerCoords - vehicleCoords)
        if distance <= Config.RangeLimit then
            inRange = true
            currentVehicle = vehicle
        else
            inRange = false
            currentVehicle = nil
        end
    else
        inRange = false
        currentVehicle = nil
    end
end

-- Function to apply performance preset
local function applyPerformancePreset(preset)
    if not inRange or not currentVehicle then return end
    local presetData = Config.PerformancePresets[preset]
    if not presetData then return end
    
    -- Apply performance modifications
    SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fInitialDriveForce', presetData.power)
    SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fTractionLossMult', presetData.traction)
    SetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fBrakeBiasFront', presetData.boost)
    
    -- Apply flame kit
    local exhaustSize = Config.FlameKit.defaultSize
    if Config.FlameKit.exhaustSizes[preset] then
        exhaustSize = Config.FlameKit.exhaustSizes[preset]
    end
    SetVehicleModKit(currentVehicle, 0)
    SetVehicleMod(currentVehicle, 4, exhaustSize, false)
    
    -- Apply backfire effect
    if Config.BackfireEffects and presetData.backfire then
        SetVehicleEngineCanDegrade(currentVehicle, true)
    else
        SetVehicleEngineCanDegrade(currentVehicle, false)
    end
    
    currentPreset = preset
end

-- Function to save preset
local function savePreset(presetName, presetData)
    local xPlayer = ESX.GetPlayerData()
    TriggerServerEvent('tuning_tablet:savePreset', xPlayer.identifier, presetName, presetData)
end

-- Function to load preset
local function loadPreset(presetName)
    local xPlayer = ESX.GetPlayerData()
    TriggerServerEvent('tuning_tablet:loadPreset', xPlayer.identifier, presetName, function(presetData)
        if presetData then
            applyPerformancePreset(presetData)
        end
    end)
end

-- Function to display vehicle data
local function displayVehicleData()
    if not inRange or not currentVehicle then return end
    local vehicleData = {
        model = GetDisplayNameFromVehicleModel(GetEntityModel(currentVehicle)),
        speed = GetEntitySpeed(currentVehicle) * 2.236936,
        rpm = GetVehicleCurrentRpm(currentVehicle),
        gear = GetVehicleCurrentGear(currentVehicle),
        traction = GetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fTractionLossMult'),
        boost = GetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fBrakeBiasFront'),
        power = GetVehicleHandlingFloat(currentVehicle, 'CHandlingData', 'fInitialDriveForce')
    }
    SendNUIMessage({
        action = 'displayVehicleData',
        data = vehicleData
    })
end

-- NUI Callback
RegisterNUICallback('applyPreset', function(data, cb)
    applyPerformancePreset(data.preset)
    cb('ok')
end)

RegisterNUICallback('savePreset', function(data, cb)
    savePreset(data.presetName, data.presetData)
    cb('ok')
end)

RegisterNUICallback('loadPreset', function(data, cb)
    loadPreset(data.presetName)
    cb('ok')
end)

-- Thread for range checking and vehicle data display
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        checkRange()
        if inRange then
            displayVehicleData()
        end
    end
end)

-- Event for police visibility
RegisterNetEvent('tuning_tablet:policeVisibility')
AddEventHandler('tuning_tablet:policeVisibility', function(playerId, visible)
    if Config.PoliceVisibility then
        local playerPed = GetPlayerPed(GetPlayerFromServerId(playerId))
        if visible then
            SetEntityVisible(playerPed, true)
        else
            SetEntityVisible(playerPed, false)
        end
    end
end)

-- Command to open tablet
RegisterCommand('tablet', function()
    if not hasDongle() then
        ESX.ShowNotification('You need a USB dongle to use the tablet')
        return
    end
    if tabletProp then
        DeleteObject(tabletProp)
        tabletProp = nil
        SetNuiFocus(false, false)
    else
        tabletProp = createTabletProp()
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'openTablet',
            presets = Config.PerformancePresets
        })
    end
end, false)