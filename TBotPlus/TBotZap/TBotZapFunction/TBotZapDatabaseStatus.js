const {TWABotLoginMPInfo, TWABotFileExist, TWABoWriteFile, TWABotOpenFile} = require('../Util/TBotZapData')


databaseStatus = ({order_id}) => {
    return new Promise((resolve, reject) => {
        if(TWABotFileExist({path: '/etc/TerminusBot/TBotZap/usuarios/pedidos.json'})){
            this.openFile('/etc/TerminusBot/TBotZap/usuarios/pedidos.json')
            .then((data) => {
               const pedido_json = JSON.parse(data)
               const order = pedido_json.find(findEl => findEl.order_id == order_id)
               resolve(order)
            })
        }
    })
}

module.exports = {
    TBotZapDBStatus: databaseStatus
}