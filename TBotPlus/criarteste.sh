#!/bin/bash
IP=$(curl -s http://whatismyip.akamai.com/)
if [ ! -d /etc/SSHPlus/userteste ]; then
mkdir /etc/SSHPlus/userteste
fi

TEMPO=$(cat /etc/TerminusBot/tempo-test)
TOKEN=$(cat /etc/TerminusBot/info-bot)
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

nome="teste"$(echo $RANDOM)
if [[ -z $nome ]]
then
	exit 1
fi
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$nome" /tmp/users
then
	 	exit 1
fi
pass=$(echo $RANDOM | 123456789 | head -c 5; echo;)
if [[ -z $pass ]]
then
	exit 1
fi
limit=1
if [[ -z $limit ]]
then
exit 1
fi
u_temp=$TEMPO
if [[ -z $u_temp ]]
then
	exit 1
fi
(( tempo = $u_temp / 60 ))
useradd -M -s /bin/false $nome
(echo $pass;echo $pass) |passwd $nome > /dev/null 2>&1
echo "$pass" > /etc/SSHPlus/senha/$nome
echo "$nome $limit" >> /root/users.db
echo "#!/bin/bash
pkill -f "$nome"
userdel --force $nome
grep -v ^$nome[[:space:]] /root/users.db > /tmp/ph ; cat /tmp/ph > /root/users.db
rm /etc/SSHPlus/senha/$nome > /dev/null 2>&1
rm -rf /etc/SSHPlus/userteste/$nome.sh
exit" > /etc/SSHPlus/userteste/$nome.sh
chmod +x /etc/SSHPlus/userteste/$nome.sh
at -f /etc/SSHPlus/userteste/$nome.sh now + $u_temp min > /dev/null 2>&1

chat_id=$1
[[ $tempo > 1 ]] && after="Horas" || after="Hora"
[[ $limit > 1 ]] && user_limit="Usuários" || user_limit="Usuário"

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


curl -s -X POST $URL -d chat_id=$chat_id -d text="
***✅ CONTA TESTE CRIADA! ✅***
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
***Servidor:*** $IP
***Usuario:*** \`$nome\`
***Senha:*** \`$pass\`
***Conexao:*** $limit $user_limit
***Duracao:*** $tempo $after
▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬
Depois do tempo de $tempo $after terminar
Sera desconectado e a conta deletada" -d parse_mode="MarkDown" -d reply_markup="$new_markup"
