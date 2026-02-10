fx_version 'cerulean'
game 'gta5'
lua54 'yes'  -- Enables modern Lua features

author 'LeafySmoke'
description 'Modular RP Framework using ox resources'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared.lua',
    'config.lua',
    'shared/utils.lua',
}

client_scripts {
    'cllient/main.lua',
    'cllient/character.lua',
    'cllient/bridge.lua',
    'bridge/qb/client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/motd.lua',
    'server/main.lua',
    'server/groups.lua',
    'server/functions.lua',
    'server/player.lua',
    'server/events.lua',
    'server/commands.lua',
    'server/loops.lua',
    'server/character.lua',
    'server/characters.lua',
    'server/money.lua',
    'server/jobs.lua',
    'server/inventory.lua',
    'server/vehicles.lua',
    'server/admin.lua',
    'server/queue.lua',
    'server/bridge.lua',
    'server/vehicle-persistence.lua',
    'bridge/qb/server/main.lua',
}

files {
    'bridge/qb/client/functions.lua',
    'bridge/qb/client/drawtext.lua',
    'bridge/qb/client/events.lua',
    'bridge/qb/shared/main.lua',
    'bridge/qb/shared/export-function.lua',
    'bridge/qb/shared/compat.lua',
}

dependencies {
    '/server:10731',
    '/onesync',
    'ox_lib',
    'oxmysql',
}

provide 'qb-core'
lua54 'yes'
use_experimental_fxv2_oal 'yes'