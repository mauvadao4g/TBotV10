
class TBotZapCreateLogin{
    create = ({chatId}) => {
        return new Promise((resolve, rejects) => {
            if(fs.existsSync("/etc/TerminusBot/TBotZap/usuarios/database_pedidos.json")){
                console.log("============ DATABASE USERSTESTERS ALREADY EXIST =======================")
                const account_ssh = fs.readFileSync("/etc/TerminusBot/TBotZap/usuarios/database_pedidos.json", {encoding: "utf-8"})
                const account_list = JSON.parse(account_ssh)
                const user = account_list.find(findEl => findEl.user_chatID == chatId)
                if(user == undefined){
                    resolve({status: "user_not_exists",})
                }else{
                    resolve({status: "user_already_exists"})
                }
            }else{
                resolve({status: "database_not_exists"})
            }
        })
    
    }
}