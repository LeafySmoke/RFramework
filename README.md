# RFramework
A FiveM RP Framework

## 🎮 Overview
RFramework is a modular roleplay framework for FiveM servers. It provides core functionality for player management, job systems, economy, and more.

## ✨ Features
- **Player Management**: Automatic player data loading and saving
- **Job System**: Configurable job system with grades and salaries
- **Economy System**: Money and bank account management
- **Database Support**: Ready for MySQL integration
- **Modern UI**: Clean, responsive HUD system
- **Utility Functions**: Extensive shared utility library
- **Server Callbacks**: Easy client-server communication
- **Modular Design**: Easy to extend and customize

## 📦 Installation

1. Clone or download this repository into your FiveM server's `resources` folder
2. Add `ensure RFramework` to your `server.cfg`
3. (Optional) Configure MySQL database connection for persistent data
4. Restart your server

## 🔧 Configuration

Edit `shared/config.lua` to customize:
- Starting money and bank amounts
- Default jobs and grades
- Spawn locations
- UI settings
- And more!

## 📖 Usage

### For Players
- The framework loads automatically when you join the server
- Your player data (money, job, etc.) is managed in the background
- A HUD displays your current stats (money, bank, job)

### For Developers

#### Getting the Framework Object
```lua
-- Server-side
local RFramework = exports['RFramework']:GetSharedObject()

-- Client-side
local RFramework = exports['RFramework']:GetSharedObject()
```

#### Server-side Functions
```lua
-- Get player object
local player = RFramework.GetPlayer(source)

-- Add/Remove money
RFramework.AddMoney(source, 'money', 1000)  -- Add $1000 cash
RFramework.RemoveMoney(source, 'bank', 500)  -- Remove $500 from bank

-- Set player job
RFramework.SetJob(source, 'police', 2)  -- Set to police grade 2
```

#### Client-side Functions
```lua
-- Check if player is loaded
if RFramework.IsPlayerLoaded() then
    -- Get player data
    local playerData = RFramework.GetPlayerData()
    print('Money: ' .. playerData.money)
end

-- Spawn player
RFramework.SpawnPlayer()

-- Teleport player
RFramework.TeleportPlayer(vector3(x, y, z), heading)
```

#### Server Callbacks
```lua
-- Client-side: Request data from server
RFramework.TriggerServerCallback('callbackName', function(result)
    print('Server responded:', result)
end, arg1, arg2)

-- Server-side: Register callback
RFramework.RegisterServerCallback('callbackName', function(source, cb, arg1, arg2)
    -- Do something
    cb(result)
end)
```

## 🎯 Server Commands

Available console commands:
- `rfversion` - Show framework version
- `rfonline` - Show online player count
- `givemoney <player_id> <money|bank> <amount>` - Give money to player
- `setjob <player_id> <job_name> <grade>` - Set player's job
- `saveall` - Save all player data
- `playerinfo <player_id>` - Show player information

## 🏗️ Directory Structure

```
RFramework/
├── client/          # Client-side scripts
├── server/          # Server-side scripts
├── shared/          # Shared scripts (client & server)
├── html/            # UI files (HTML, CSS, JS)
├── config/          # Configuration files
├── data/            # Data files
└── fxmanifest.lua   # Resource manifest
```

## 🔌 Extending the Framework

### Adding New Jobs
Edit `shared/config.lua` and add to `Config.Jobs`:
```lua
["yourjob"] = {
    label = "Your Job Name",
    grades = {
        [0] = { name = "Trainee", salary = 10 },
        [1] = { name = "Employee", salary = 20 }
    }
}
```

### Creating Custom Modules
You can create additional scripts that utilize RFramework:
```lua
-- Get framework object
local RFramework = exports['RFramework']:GetSharedObject()

-- Use framework functions
-- Your code here
```

## 📝 Database Schema

When MySQL is enabled, the framework will create the following table:
```sql
CREATE TABLE `rf_players` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `money` INT(11) NOT NULL DEFAULT 5000,
    `bank` INT(11) NOT NULL DEFAULT 10000,
    `job` VARCHAR(50) NOT NULL DEFAULT 'unemployed',
    `job_grade` INT(11) NOT NULL DEFAULT 0,
    `inventory` LONGTEXT NULL DEFAULT NULL,
    `metadata` LONGTEXT NULL DEFAULT NULL,
    `last_seen` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `identifier` (`identifier`)
);
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

## 📄 License

This project is open source and available for use in FiveM servers.

## 💡 Support

For issues and questions, please use the GitHub issue tracker.

---

**Made with ❤️ for the FiveM community** 
