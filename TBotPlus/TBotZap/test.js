const { rejects } = require('assert');
const fs = require('fs');
const { resolve } = require('path');
const { exec } = require('child_process');
const {TWABotLoginMPInfo, TWABoWriteFile, TWABotOpenFile, TWABotFileExist} = require('./Util/TBotZapData')
const { TBotZapSendLogin } = require('./TBotZapClass/TBotZapSendLogin')
const axios = require('axios')
const { default: makeWASocket, useMultiFileAuthState, MessageRetryMap, Presence, DisconnectReason, delay}  = require('@adiwajshing/baileys')
const P = require('pino')

if(fs.existsSync('/etc/TerminusBot/TBotZap/usuarios/account_recovery.json')){
    const recovery_file = TWABotOpenFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json'})
  const recovery_json = JSON.parse(recovery_file)
        recovery_json.push({
            "ssh_account": "fe4005f79",
            "ssh_password": "61497",
            "ssh_expire": "30 dias",
            "ssh_limit": "1 usuario",
            "order_id": "25011401775",
            "chat_id": "554891629331@s.whatsapp.net"
        })   
        console.log(recovery_json)
}
 
