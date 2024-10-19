#!/bin/bash

sshPlusUserCreate(){
TOKEN=$(cat /etc/TerminusBot/info-bot)
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

paymentId=$(echo $1 | cut -d"|" -f 1)
chat_id=$(echo $1 | cut -d"|" -f 4)
expire=$(echo $1 | cut -d"|" -f 5)
limit=$(echo $1 | cut -d"|" -f 6)


# Comando para pegar o IP da máquina
IP=$(curl -s http://whatismyip.akamai.com/)
#USERNAME Uso no máximo 10 caracteres - Maior que dois digitos - Não use espaço, acentos ou caracteres especiais - Não pode ficar vazio
username=$(echo $RANDOM | md5sum | head -c 9; echo;)
#PASSWORD Número no minimo 4 digitos - Não pode ficar vazio. 
password=$(echo $RANDOM | md5sum | head -c 5; echo;)
#SSHLIMITER Deve ser maior que zero - Apenas número - Não pode ficar vazio
sshlimiter=$limit
# DIAS Deve ser maior que zero - Deve ser apenas número - Não pode ficar vazio
dias=$expire

final=$(date "+%Y-%m-%d" -d "+$dias days")
gui=$(date "+%d/%m/%Y" -d "+$dias days")
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -e $final -M -s /bin/false -p $pass $username >/dev/null 2>&1 &
echo "$password" >/etc/SSHPlus/senha/$username
echo "$username $sshlimiter" >>/root/usuarios.db
 
link_playstore=`cat /etc/TerminusBot/link_playstore`
link_mediafire=`cat /etc/TerminusBot/link_mediafire`

[[ -z $link_playstore ]] && link_playstore="https://www.google.com/"
[[ -z $link_mediafire ]] && link_mediafire="https://www.google.com/"

new_markup='{
	"inline_keyboard": [
     [
      		{
        	"text": "PLAY STORE",
        	"callback_data": "play_store",
			"url": "'${link_playstore}'"
      		}
    ],
    [
      		{
        	"text": "LINK ONLINE",
        	"callback_data": "mediafire",
			"url": "'${link_mediafire}'"
      		}
    ]
  ]
}'

curl -s -X POST $URL -d chat_id=$chat_id  -d text="
	***✅ CONTA SSH CRIADA! ✅***
    ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
	***IP:*** $IP
	***Usuário:*** \`$username\`
	***Senha:*** \`$password\`
	***Expira em:*** $gui
	***Limite de conexões:*** $sshlimiter
	***Pedido:*** $paymentId
    ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
	Obrigado pela preferência!" -d parse_mode="MarkDown" -d reply_markup="$new_markup"
}


sshPlusUserCreate $1
