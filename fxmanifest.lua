fx_version 'cerulean'
game 'gta5'

author "Mady by Zadran.cfx"
description 'Custom ramenwasser job voor ESX!'
version '4.0.0'

shared_script 'config.lua'
shared_script 'locales/nl.lua'

client_script 'client/main.lua'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}
