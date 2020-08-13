fx_version 'bodacious'

game 'gta5'

description 'ESX Minebitcoins'

client_script {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'locales/no.lua',
    'config.lua',
    'client/main.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'locales/en.lua',
    'locales/no.lua',
    'config.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'mhacking',
    'progressBars',
    'esx_addons_gcphone'
}



