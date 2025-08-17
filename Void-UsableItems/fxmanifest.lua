fx_version 'cerulean'
game 'gta5'

author 'Void Scripts'
description 'UsableItems Script for ox_inventory/qb_inventory with ox_lib integration'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'ox_lib',
    'qb-core'
}

lua54 'yes'
