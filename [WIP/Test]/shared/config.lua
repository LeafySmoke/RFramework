Config = {}

-- Framework Configuration
Config.Framework = {
    Name = "RFramework",
    Version = "1.0.0",
    Debug = false
}

-- Player Configuration
Config.Player = {
    StartingMoney = 5000,
    StartingBank = 10000,
    MaxInventorySlots = 50,
    DefaultJobName = "unemployed",
    DefaultJobGrade = 0
}

-- Database Configuration
Config.Database = {
    Enabled = true,
    UseMySQL = true,
    TablePrefix = "rf_"
}

-- UI Configuration
Config.UI = {
    ShowPlayerHUD = true,
    ShowMinimap = true,
    DefaultLanguage = "en"
}

-- Job System Configuration
Config.Jobs = {
    ["police"] = {
        label = "Police Department",
        grades = {
            [0] = { name = "Recruit", salary = 20 },
            [1] = { name = "Officer", salary = 40 },
            [2] = { name = "Sergeant", salary = 60 },
            [3] = { name = "Lieutenant", salary = 85 },
            [4] = { name = "Captain", salary = 100 },
            [5] = { name = "Chief", salary = 120 }
        }
    },
    ["ambulance"] = {
        label = "Emergency Medical Services",
        grades = {
            [0] = { name = "Trainee", salary = 20 },
            [1] = { name = "Paramedic", salary = 40 },
            [2] = { name = "Doctor", salary = 60 },
            [3] = { name = "Surgeon", salary = 80 },
            [4] = { name = "Chief Surgeon", salary = 100 }
        }
    },
    ["mechanic"] = {
        label = "Mechanic",
        grades = {
            [0] = { name = "Apprentice", salary = 12 },
            [1] = { name = "Mechanic", salary = 24 },
            [2] = { name = "Chief Mechanic", salary = 36 },
            [3] = { name = "Manager", salary = 48 }
        }
    },
    ["unemployed"] = {
        label = "Unemployed",
        grades = {
            [0] = { name = "Unemployed", salary = 0 }
        }
    }
}

-- Spawn Configuration
Config.Spawn = {
    Locations = {
        { coords = vector3(-269.4, -955.3, 31.2), heading = 205.8 },
        { coords = vector3(195.17, -933.77, 29.7), heading = 144.5 },
        { coords = vector3(447.0, -992.0, 30.68), heading = 87.0 }
    }
}
