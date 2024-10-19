
const { TWABotLoginMPInfo, TWABotFirsLoginPrice, TWABoWriteFile, TWABotFileExist, TWABotOpenFile } = require('../Util/TBotZapData')
const fs = require('fs')
const axios = require('axios').default;

class QRcode {
    generate =  ({chatId}) => {
       return new Promise( async (resolve, reject) => {
            try {
                const response = await axios.post('https://api.mercadopago.com/v1/payments', `{
                    "transaction_amount":  `+parseFloat(TWABotFirsLoginPrice())+`,
                    "description": "Título do produto",
                    "payment_method_id": "pix",
                    "payer": {
                    "email": "test@test.com",
                    "first_name": "Test",
                    "last_name": "User",
                    "identification": {
                        "type": "CPF",
                        "number": "19119119100"
                    },
                    "address": {
                        "zip_code": "06233200",
                        "street_name": "Av. das Nações Unidas",
                        "street_number": "3003",
                        "neighborhood": "Bonfim",
                        "city": "Osasco",
                        "federal_unit": "SP"
                    }
                    }
                }`, {
                    headers: {
                        'content-type': 'application/json',
                        'Authorization': `Bearer ${TWABotLoginMPInfo()}`
                    
                    }
                }
            )
            this.saveOrder({orderId: response.data.id, chatId: chatId})
            .then((order) =>  {
                if(order.status){
                    //{status: true, qrCode: response.data.point_of_interaction.transaction_data.qr_code, chat: chatId, orderId: response.data.id}
                    resolve({status: true, qrCode: response.data.point_of_interaction.transaction_data.qr_code, chat: chatId, orderId: response.data.id})
                }else{
                    resolve({status: false})
                }
            })

            } catch (error) {
                reject(error)
            }            

          
       })
        
    }

    saveOrder = ({orderId, chatId}) => {
        return new Promise((resolve, reject) => {
            
            var  newOrder = {"order_id": orderId, "chat_id":  chatId, "status": "pending", "send":false}
           
          
            if( TWABotFileExist({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json'})){
                console.log('============= ORDER FILE  EXIST ===============')
               try {
                const order_file = TWABotOpenFile({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json'})
                if(order_file.length > 0){
                    const order_json = JSON.parse(order_file)
                    order_json.push(newOrder)
                    if( TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json', file: order_json})){
                        console.log("============= PEDIDO FOI SALVO COM SUCESSO =================")
                        resolve({status: true})
                    }else{
                        resolve({status: false})
                        console.log("============= ERRO AO SALVAR PEDIDO =================")
                    }
                    
                }
               } catch (error) {
                    console.log(error)
               }

            }else{
                const order_list = []
                order_list.push(newOrder)
                console.log('============= ARQUIVO PEDIDO NÃO EXISTE ===============')
                if(TWABoWriteFile({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json', file: order_list})){
                    console.log('============= PEDIDO FOI SALVO COM SUCESSO ===============')
                    resolve({status: true})
                }else{
                    console.log('============= ERRO AO SALVA PEDIDO ===============')
                    resolve({status: false})
                }
                
            }
        })
    }
}

module.exports.QRcode = new QRcode