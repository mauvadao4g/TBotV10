const chat_id = process.argv.slice(2)[0]
const order_id = process.argv.slice(3)[0]
console.log(chat_id)
console.log(order_id)
const {TWABotLoginMPInfo, TWABotFileExist, TWABoWriteFile, TWABotOpenFile, TWABotLinkPlayStore, TWABotLinkMediafire} = require('./Util/TBotZapData')
const { default: makeWASocket, useMultiFileAuthState, MessageRetryMap, Presence, DisconnectReason, delay}  = require('@adiwajshing/baileys')
const P = require('pino')
const { exec } = require('child_process');
const fs = require('fs')

createSSH = ({order_id, chat_id}) => {
    return new Promise((resolve, rejects) => {
       
        exec(`bash /etc/TerminusBot/TBotZap/shell/criarusuario.sh`, (error, stdout, stderr) => {
            if(stdout){
                const ssh_account = JSON.parse(stdout)
                const payload_ssh = {
                    ssh_account: `${ssh_account.Usuario}`,
                    ssh_password: `${ssh_account.Senha}`,
                    ssh_expire: `${ssh_account.expira}`,
                    ssh_limit: `${ssh_account.limite}`,
                    order_id: `${order_id}`,
                    chat_id: `${chat_id}`

                }
                resolve({status: true, payload: payload_ssh})
                
            }else if(error){
                rejects({status: false})
            }
        })
       
    })
}

attOrderStatus = ({orderId}) => {
    return new Promise((resolve, reject) => {
        console.log("#############    -->  ATT STATUS ############")
        try {
            
            if(TWABotFileExist({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json'})){
            
                console.log("#############    -->  FILE ORDER EXIST ############")
                openFile('/etc/TerminusBot/TBotZap/usuarios/pedidos.json')
                .then((pedido_file) => {
                    const pedido_json = JSON.parse(pedido_file)
                    const user_data = pedido_json.find(findEl => findEl.order_id == orderId)
                    if(user_data != undefined){
                        user_data.status = "approved"
                    }

                    const result = TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json', file: pedido_json})
                    if(result.status){
                        resolve({status: true, payload: user_data})
                    }
                })
                
            }
    
        } catch (error) {
            reject(error)   
        }
       })
}

openFile  = (path) => { 
    return new Promise((resolve, rejects) => {
        try{
            resolve(fs.readFileSync(path, "utf-8"))
        }catch(e){
            rejects(e)
        }
    
    })
}

tbotConection = () => {
    return new Promise( async (resolve, reject) => {
      const { state, saveCreds } = await useMultiFileAuthState('/etc/TerminusBot/TBotZap/auth_info_baileys')
      this.conn = makeWASocket({
          logger: P({ level: 'silent' }),
              printQRInTerminal: true,
              auth: state,
              msgRetryCounterMap: MessageRetryMap,
              defaultQueryTimeoutMs: undefined, 
              keepAliveIntervalMs: 1000 * 60 * 10 * 3
  
      })

      this.conn.ev.on('connection.update', (update) => {
          const { connection, lastDisconnect } = update
         if(connection === 'open') {
              console.log('opened connection')
              resolve({status: true, connection: this.conn})
              
          }else if(connection === 'close'){
              resolve({status: false})
          }

      })
    })
  }


  sendMessage = ({account}) => {
      return new Promise((receive, reject) => {
 
          console.log("============== PREPARANDO  SSH PARA ENVIAR AO CLIENTE ===================")
        
          this.conn.sendMessage(account.payload.chat_id, {text: `
*CONTA CRIADA COM SUCESSO!*
*Usuário:* ${account.payload.ssh_account}
*Senha:* ${account.payload.ssh_password}
*Expira:* ${account.payload.ssh_expire}
*Limite:* ${account.payload.ssh_limit}
*Pedido:* ${order_id}
▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
Link de download
PlayStore: ${TWABotLinkPlayStore()}
MediaFire: ${TWABotLinkMediafire()}
▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
Obrigado por adquirir nosso produto.`})
          receive(true)
      })
  }

  saveUserToRecovery = ({account_ssh, orderId}) => {
    return new Promise((resolve, reject) => {
        if(fs.existsSync('/etc/TerminusBot/TBotZap/usuarios/account_recovery.json')){
            const recovery_file = TWABotOpenFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json'})
            account_ssh.order_id = orderId
            if(recovery_file.length > 0){
                const recovery_json = JSON.parse(recovery_file)
                recovery_json.push(account_ssh)
                TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json', file: recovery_json})
                resolve()
    
            }else{
                TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json', file: [account_ssh]})
                resolve()
            }
        }else{
            TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json', file: [account_ssh]})
            resolve()
        }
    })
}

createSSH({order_id: order_id, chat_id: chat_id}).then((response) => {
   if(response.status){
        tbotConection().then((result) => {
            if(result.status){
                console.log("============= CONNECTED ================")
                console.log(response.payload)
                sendMessage({account: response})
                .then((status) => {
                    if(status){
                      attOrderStatus({orderId: response.payload.order_id})
                      .then((data) => {
                           if(data.status){
                                saveUserToRecovery({account_ssh: response.payload, orderId: response.payload.order_id})
                                .then(() => {
                                        console.log("======= CONTA ENVIADA ========")
                                        setTimeout(() => {
                                            console.log("======= DESCONECTED ========")
                                            process.exit(0)
                                        }, 10000)  
                                })
                           }
                      })
                    }
                })
            }
        })
   }
})