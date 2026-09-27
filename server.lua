local ESX = exports['es_extended']:getSharedObject()

-- Function to save preset
RegisterServerEvent('tuning_tablet:savePreset')
AddEventHandler('tuning_tablet:savePreset', function(playerId, presetName, presetData)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('INSERT INTO tuning_tablet_presets (player_id, preset_name, traction, boost, power, exhaust_size, backfire_effect) VALUES (@player_id, @preset_name, @traction, @boost, @power, @exhaust_size, @backfire_effect)', {
        ['@player_id'] = xPlayer.identifier,
        ['@preset_name'] = presetName,
        ['@traction'] = presetData.traction,
        ['@boost'] = presetData.boost,
        ['@power'] = presetData.power,
        ['@exhaust_size'] = presetData.exhaustSize,
        ['@backfire_effect'] = presetData.backfireEffect
    }, function(rowsChanged)
        if rowsChanged > 0 then
            xPlayer.showNotification('Preset saved successfully')
        else
            xPlayer.showNotification('Failed to save preset')
        end
    end)
end)

-- Function to load preset
RegisterServerEvent('tuning_tablet:loadPreset')
AddEventHandler('tuning_tablet:loadPreset', function(playerId, presetName, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM tuning_tablet_presets WHERE player_id = @player_id AND preset_name = @preset_name', {
        ['@player_id'] = xPlayer.identifier,
        ['@preset_name'] = presetName
    }, function(result)
        if result[1] then
            local presetData = {
                traction = result[1].traction,
                boost = result[1].boost,
                power = result[1].power,
                exhaustSize = result[1].exhaust_size,
                backfireEffect = result[1].backfire_effect
            }
            cb(presetData)
        else
            cb(nil)
        end
    end)
end)

-- Event for police visibility
RegisterServerEvent('tuning_tablet:policeVisibility')
AddEventHandler('tuning_tablet:policeVisibility', function(playerId, visible)
    TriggerClientEvent('tuning_tablet:policeVisibility', -1, playerId, visible)
end)