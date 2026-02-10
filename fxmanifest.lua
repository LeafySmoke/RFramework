fx_version 'cerulean'
game 'gta5'

author 'LeafySmoke'
description 'RFramework - A FiveM RP Framework'
version '1.0.0'

-- Shared scripts (used by both client and server)
shared_scripts {
    'shared/config.lua',
    'shared/utils.lua'
}

-- Client scripts
client_scripts {
    'client/main.lua',
    'client/player.lua',
    'client/nui.lua'
}

-- Server scripts
server_scripts {
    'server/main.lua',
    'server/player.lua',
    'server/database.lua',
    'server/commands.lua'
}

-- Files
files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'config/config.json'
}

-- UI page
ui_page 'html/index.html'
