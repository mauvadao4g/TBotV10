const { default: makeWASocket, useMultiFileAuthState, MessageRetryMap, Presence, DisconnectReason, delay}  = require('@adiwajshing/baileys')
const { exec } = require('child_process');
const path = require("path");
const { util } = require('util')


async function connectToWhatsApp(){
    const { state, saveCreds } = await useMultiFileAuthState('/etc/TerminusBot/TBotZap/auth_info_baileys')

        
    const conn = makeWASocket({ auth: state, printQRInTerminal: true });
    conn.ev.on('connection.update', async (update) => {
        const { connection, lastDisconnect } = update
        if(connection === 'close') {
            const shouldReconnect = lastDisconnect.output !== DisconnectReason.loggedOut
            console.log('connection closed due to'+ lastDisconnect.output)
            // reconnect if not logged out
            if(shouldReconnect) {
                connectToWhatsApp()
            }
        
        } else if(connection === 'open') {
            console.log('opened connection')   
            delay(200)
            process.exit()
        }
    })

    conn.ev.on("creds.update", saveCreds);
   
        
}

connectToWhatsApp()