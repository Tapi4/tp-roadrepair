fx_version 'cerulean'
game 'gta5'

author 'Tapi'
description 'Road Repair Job with Memory Game'
version '1.0.0'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    'server.lua',
    'config.lua'
}

dependency {
    'progressbar',
    'qb-core',
}

ui_page 'html/drilling_game.html'

files {
    'html/drilling_game.html'
}
