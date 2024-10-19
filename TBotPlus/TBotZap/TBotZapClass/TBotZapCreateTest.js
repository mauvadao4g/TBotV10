const { rejects } = require('assert');
const fs = require('fs');
const { resolve } = require('path');
const { exec } = require('child_process');
const {TWABotOpenFile} = require('../Util/TBotZapData')

class TBotZapLoginTest {
    create = (jid) => {
      return new Promise((resolve, rejects) => {

        if(fs.existsSync("/etc/TerminusBot/TBotZap/usuarios/database_users_testers.json")){
            console.log("============ DATABASE  ALREADY EXIST =======================")
            const hasData = TWABotOpenFile({path:'/etc/TerminusBot/TBotZap/usuarios/database_users_testers.json'})
            if(hasData.length > 0){

                const account_ssh = fs.readFileSync("/etc/TerminusBot/TBotZap/usuarios/database_users_testers.json", {encoding: "utf-8"})
                const account_list = JSON.parse(account_ssh)
                const user = account_list.find(findEl => findEl.user_chatID == jid)
                if(user == undefined){
                    resolve({status: "user_not_exists"})
                    console.log({status: "user_not_exists",})
                }else{
                    
                    resolve({status: "user_already_exists"})
                    console.log({status: "user_already_exists", user_account: user})
                }

            }else{
                resolve({status: "database_not_exists"})
                console.log({status: "database_not_exists"})
            }
           
        }else{
            resolve({status: "database_not_exists"})
            console.log({status: "database_not_exists"})
        }

      })
    
    }
    createTestAndDatabase = ({userId}) => {
        return new Promise((resolve, rejects) => {
            exec(`bash /etc/TerminusBot/TBotZap/shell/criarteste.sh`, async (error, stdout, stderr) => {
                const account = JSON.parse(stdout)
                
                const account_test = 
                {
                    "chat_id": userId,
                    "IP": account.IP,
                    "usuario": account.Usuario,
                    "senha": account.Senha,
                    "expira": account.expira,
                    "limite": account.limite,
                }
                this.createDatabase({userId: userId})
                .then(() => resolve(account_test))
            });
        })
    }

    createTest = ({userId}) => {
        return new Promise((resolve, rejects) => {
            exec(`bash /etc/TerminusBot/TBotZap/shell/criarteste.sh`, async (error, stdout, stderr) => {
                const account = JSON.parse(stdout)
                
                const account_test = 
                {
                    "chat_id": userId,
                    "IP": account.IP,
                    "usuario": account.Usuario,
                    "senha": account.Senha,
                    "expira": account.expira,
                    "limite": account.limite,
                }
                this.updateDatabase({id: userId})
                .then(() => resolve(account_test))
            });
        })
    }

    updateDatabase = ({id}) => {
       return new Promise((resolve, rejects) => {
            const new_account = { user_chatID: id}
            const data =  fs.readFileSync('/etc/TerminusBot/TBotZap/usuarios/database_users_testers.json', "utf-8")
            const account_parse = JSON.parse(data)
            account_parse.push(new_account)
            fs.writeFile('/etc/TerminusBot/TBotZap/usuarios/database_users_testers.json', JSON.stringify(account_parse), (error, bytes) => {
               resolve()
            })
       })
    }
    createDatabase = ({userId}) => {
        return new Promise((resolve, rejects) => {
            const new_account = { user_chatID: userId}
            const account_drawer = []
            account_drawer.push(new_account)
            fs.writeFile('/etc/TerminusBot/TBotZap/usuarios/database_users_testers.json', JSON.stringify(account_drawer), (error, bytes) => {
               resolve()
            })

        })
       
    }
}

module.exports.TBotZapLoginTest = new TBotZapLoginTest()