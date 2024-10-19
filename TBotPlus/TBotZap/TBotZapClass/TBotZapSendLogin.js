
const {TWABotLoginMPInfo, TWABotFileExist, TWABoWriteFile, TWABotOpenFile} = require('../Util/TBotZapData')
const axios = require('axios').default
const fs = require('fs')
const { exec } = require('child_process');

class TBotZapSendLogin {

    paymentStatus = ({orderId}) => {
        return new Promise((resolve, reject) => {
            axios({
                method: 'GET',
                url: `https://api.mercadopago.com/v1/payments/${orderId}`,
                headers:  {
                    'content-type': 'application/json',
                    'Authorization': `Bearer ${TWABotLoginMPInfo()}`
                
                }
            })
            .then((response) => {
                resolve(response.data.status)
                
            })
            .catch(function (error) {
                console.log('================= STATUS PAYMENT ERRO ==================')
                reject(error)
            })
        
        })
    
    }

    checkPaymentStatus = () => 
    {
        const token = TWABotLoginMPInfo()
     
        return new Promise(  (resolve, rejects) => 
        {
            if(TWABotFileExist({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json'})){
                this.openFile('/etc/TerminusBot/TBotZap/usuarios/pedidos.json')
                .then((data) => {
                    if(data){
                        let i = 0
                        const pedido_json = JSON.parse(data)
                        for( i in pedido_json){
                            let order = pedido_json[i].order_id
                            let status = pedido_json[i].status
                            console.log(status)
                            if(status == "pending"){
                                this.paymentStatus({orderId: order})
                                .then((response) => {
                                    resolve({status: response, order_id: order})
                                })
                            }
                        
                        }
                      
                    }
                })
            }
        })
    }

    
    
    attOrderStatus = ({orderId}) => {
        return new Promise((resolve, reject) => {
            console.log("#############    -->  ATT STATUS ############")
            try {
                
                if(TWABotFileExist({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json'})){
                
                    console.log("#############    -->  FILE ORDER EXIST ############")
                    this.openFile('/etc/TerminusBot/TBotZap/usuarios/pedidos.json')
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

    saveUserToRecovery = ({account_ssh}) => {
        if(TWABotFileExist('/etc/TerminusBot/TBotZap/usuarios/account_recovery.json')){
            const recovery_file = TWABotOpenFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json'})
            if(recovery_file.length > 0){
                const recovery_json = JSON.parse(recovery_file)
                recovery_json.push(account_ssh.payload)
                TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json', file: recovery_json})

            }else{
                TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json', file: [account_ssh.payload]})
            }
        }else{
            TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/account_recovery.json', file: [account_ssh.payload]})
        }
    }
}

module.exports.TBotZapSendLogin = new TBotZapSendLogin()