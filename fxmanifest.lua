fx_version "cerulean"
game "gta5"

author "Venado"
title "LB Phone - Job Selector"
description "An app to select your current job."

dependencies {
    'qbx_core',
    'ox_lib',
    'lb-phone'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client/main.lua'
server_script 'server.lua'

ui_page "ui/dist/index.html"

files {
    "ui/dist/**/*"
}