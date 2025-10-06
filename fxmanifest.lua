fx_version "cerulean"
game "gta5"

author "Venado"
title "LB Phone - Job Selector"
description "An app to select your current job."
version "1.0.0"

dependencies {
    'qbx_core'
}

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server.lua'

ui_page "ui/dist/index.html"

files {
    "ui/dist/**/*"
}
