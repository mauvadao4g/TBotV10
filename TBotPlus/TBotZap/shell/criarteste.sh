#!/bin/bash
IP=$(curl -s http://whatismyip.akamai.com/)
if [ ! -d /etc/SSHPlus/userteste ]; then
mkdir /etc/SSHPlus/userteste
fi

TEMPO=$(cat /etc/TerminusBot/tempo-test)
TOKEN=$(cat /etc/TerminusBot/info-bot)
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

nome="teste-"$(echo $RANDOM)
if [[ -z $nome ]]
then
	exit 1
fi
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$nome" /tmp/users
then
	 	exit 1
fi
pass=$(echo $RANDOM | md5sum | head -c 5; echo;)
if [[ -z $pass ]]
then
	exit 1
fi
limit=1
if [[ -z $limit ]]
then
exit 1
fi
u_temp=$(cat /etc/TerminusBot/tempo-test)
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

echo '{
        "IP": "'${IP}'",
        "Usuario": "'${nome}'",
        "Senha": "'${pass}'",
        "expira": "'${tempo}'",
        "limite": "1 usuario"
      }'