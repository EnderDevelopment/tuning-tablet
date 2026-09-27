Config = {}

-- USB Dongle Requirement
Config.RequireDongle = true

-- Range Limit
Config.RangeLimit = 5.0

-- Police Visibility
Config.PoliceVisibility = true

-- Performance Presets
Config.PerformancePresets = {
    ['eco'] = {traction = 0.8, boost = 0.5, power = 0.7},
    ['normal'] = {traction = 1.0, boost = 1.0, power = 1.0},
    ['sport'] = {traction = 1.2, boost = 1.5, power = 1.3},
    ['track'] = {traction = 1.5, boost = 2.0, power = 1.5}
}

-- Anti-Lag System
Config.AntiLag = true

-- Flame Kit
Config.FlameKit = {
    exhaustSizes = {small = 0.5, medium = 1.0, large = 1.5},
    defaultSize = 'medium'
}

-- Backfire Effects
Config.BackfireEffects = true

-- Synchronized Animations
Config.SynchronizedAnimations = true

-- UI Settings
Config.UI = {
    bootScreenDuration = 3000,
    tabletModel = 'prop_cs_tablet'
}