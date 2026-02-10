Config = {}

Config.StartingMoney = 5000
Config.DefaultJob = 'unemployed'
Config.Jobs = {
    unemployed = { label = 'Unemployed', defaultDuty = true, grades = {['0'] = {name = 'Freelancer', payment = 10}} },
    police = { label = 'Police', defaultDuty = false, grades = {['0'] = {name = 'Recruit', payment = 50}} }
}

Config.Spawn = vector4(-258.21, -293.08, 21.61, 206.0)