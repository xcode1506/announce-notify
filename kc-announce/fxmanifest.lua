fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Hugo'
description 'Announcement System'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',

    'html/images/*.png',
    'html/sounds/*.ogg'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}