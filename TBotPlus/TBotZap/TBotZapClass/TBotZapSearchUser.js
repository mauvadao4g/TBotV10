const fs = require("fs")

class UsersDB {
    
    dbDir = "/etc/TerminusBot/TBotZap/usuarios/database_users.json"
    
    createUserDatabase({newUser}){
        
        fs.stat(this.dbDir, (error, stats) => {
           if(error){
            fs.writeFile(this.dbDir, JSON.stringify([newUser], null, 4), (error, bytes) => {
                if(error){
                    console.log(`Erro ao salvar pedido: ${error}`)
                }
                if(bytes){
                    console.log(`Pedido salvo com sucesso! ${bytes}`)
                }
              });

           }else{
               console.log("===== DB EXIST =====")
               fs.readFile(this.dbDir, {encoding: 'utf-8'}, async (error, data) => {
                const array = JSON.parse(data)
                array.push(newUser)
                fs.writeFile(this.dbDir, JSON.stringify(array, null, 4), (error, bytes) => {
                    if(error){
                        console.log(`Erro ao salvar pedido: ${error}`)
                    }
                    if(bytes){
                        console.log(`Pedido salvo com sucesso! ${bytes}`)
                    }
                  });
              })
               
           }
        })
    }

    searchAndGetUser({chatId, callback}){
        const list_user_accounts = []
        if(fs.existsSync("/etc/TerminusBot/TBotZap/usuarios/database_users.json")){
            const database_file = fs.readFileSync("/etc/TerminusBot/TBotZap/usuarios/database_users.json", {encoding: "utf-8"})
            if(database_file != undefined){
                if(database_file.length > 0){
                    const database_json = JSON.parse(database_file)
                    database_json.account.forEach(element => {
                        if(element.chat_id == chatId){
                            list_user_accounts.push(element)
                        }
                    });
                    callback(list_user_accounts)
                }
            }
        }
    }
}


module.exports.UsersDB = new UsersDB()