# Tuning Tablet

Enhance your FiveM experience with customizable vehicle tuning presets.

## Features

- Multiple performance presets (Eco, Normal, Sport, Track)
- USB dongle requirement for added realism
- Police visibility feature
- Vehicle data display
- Preset saving and loading functionality

## Requirements

- FiveM server with ESX framework
- MySQL database

## Installation

1. Download the script files
2. Place them in your FiveM server's resources folder
3. Add `start tuning_tablet` to your server.cfg
4. Import the database.sql file into your MySQL database

## Usage

- Use the `/tablet` command to open the tuning tablet
- Select a performance preset to apply to your vehicle
- Save and load custom presets

## Configuration

Edit the `config.lua` file to customize the script:

- `Config.RequireDongle`: Set to `true` to require a USB dongle
- `Config.RangeLimit`: Adjust the range limit for tuning
- `Config.PoliceVisibility`: Enable or disable police visibility
- `Config.PerformancePresets`: Customize the performance presets

---

## Generated with EnderDevelopment

This plugin was generated in minutes with [EnderDevelopment](https://enderdevelopment.com) — the AI platform that turns your ideas into working Minecraft plugins, Discord bots and FiveM scripts.

**Want your own?** [Generate this project on EnderDevelopment](https://dash.enderdevelopment.com?utm_source=github&utm_medium=readme&utm_campaign=tuning-tablet&utm_content=bottom) — describe it in one sentence and get the full source code.