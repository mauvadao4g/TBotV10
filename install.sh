#!/bin/bash
clear
    echo -e "\E[44;1;37m     INSTALAÇÃO DO BOT VENDAS     \E[0m"
    echo -e "\nINSTALANDO AGUARDE...."
    echo ""

progress(){
while :
do
    for loading in "Oooo | Loading | oooO" "oOoo | Loading | ooOo" "ooOo | Loading | oOoo" "oooO | Loading | Oooo"; do
        clear
        echo -e "\t \e[41;5;1;33mAguarde\e[0m"
        echo -ne "\e[1;36m$loading\e[0m"
        sleep 2

    done

done
}

pacotes(){
apt update -y > /dev/null 2>&1 && apt install jq sshpass curl at -y > /dev/null 2>&1
}

concluido(){
figlet -c MauDaVPn
echo -e "\033[1;32mINSTALADO COM SUCESSO! \n\033[1;33mPARA ATIVAR  O BOT EXECULTE O COMANDO \033[1;32mautobot \
\n\n\033[1;33mANTES DE ATIVAR CERTIFIQUE-SE QUE ADICONOU AS CREDENCIAIS\nDO BOT E MERCADOPAGO\n\033[1;31mCOMANDOS LOGO ABAIXO:\033[0m\nCOMANDO1: .....\nCOMANDO2: ...."
}

baixarBOT(){
git clone https://github.com/mauvadao4g/TBotV10.git
cd TBotV10
bash run.sh
}

progress&
PID=$!
   baixarBOT
   $(kill $PID)
   sleep 3
   concluido
echo
# echo "[-] Para iniciar o menu na proxima vez digite: ${Yellow}\"terminus\"${Norm}"
echo -ne "\n\033[1;32m@MAUVADAO\033[1;37m: "

