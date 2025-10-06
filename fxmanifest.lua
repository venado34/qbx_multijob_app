fx_version 'cerulean'
game 'gta5'

author 'Venado'
title 'LB Phone - Job Selector'
description 'An app to select your current job.'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/main.lua'
}

server_script 'server.lua'

ui_page "ui/dist/index.html"

files {
    "ui/dist/**/*"
}

dependencies {
    'qbx_core',
    'lb-phone',
    'ox_lib'
}
