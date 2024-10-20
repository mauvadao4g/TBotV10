#!/bin/bash
clear
echo -e "\E[44;1;37m     INSTALAÇÃO DO BOT VENDAS     \E[0m"
echo -e "\nINSTALANDO, AGUARDE...."
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
    if command -v figlet > /dev/null 2>&1; then
        figlet -c MauDaVPn
    else
        echo -e "\033[1;33mFiglet não instalado, instalando...\033[0m"
        apt install figlet -y > /dev/null 2>&1
        figlet -c MauDaVPn
    fi
    echo -e "\033[1;32mINSTALADO COM SUCESSO! \n\033[1;33mPARA ATIVAR O BOT EXECUTE O COMANDO \e[1;32m terminus\e[0m"
    echo -e "\n\033[1;33mANTES DE ATIVAR, CERTIFIQUE-SE DE QUE ADICIONOU AS CREDENCIAIS\nDO BOT E MERCADOPAGO\n\033[1;31mCOMANDOS LOGO ABAIXO:\033[0m\nCOMANDO1: terminus"
}

baixarBOT(){
    if [ ! -d "TBotV10" ]; then
        git clone https://github.com/mauvadao4g/TBotV10.git >/dev/null 2>&1 || echo -e '\e[1;31mError\e[0m'
        sleep 2
        clear
    fi
    cd TBotV10
 #   bash run.sh
}

alocar_bot(){
# Entrar na pasta principal pra copiar os arquivos
[[ ! -d TBotPlus ]] && { echo '\e[1;31mPasta não existe: TBotPlus\e[0m'; exit 1; } || cd TBotPlus
    cp TerminusBot.sh terminus
    chmod +x terminus
    cp terminus /bin
#   mv terminus TerminusBot.sh
    chmod +x TerminusBot.sh

}


# Iniciar barra de progresso em segundo plano
 progress&
 PID2=$!

# Baixar e executar o bot
baixarBOT
alocar_bot
cp -rf ./* /etc/TerminusBot/
# Finalizar barra de progresso
 kill -9 $PID2
 wait $PID2

sleep 1
concluido
echo

# echo "[-] Para iniciar o menu na próxima vez digite: ${Yellow}\"terminus\"${Norm}"
echo -ne "\n\033[1;32m@MAUVADAO\033[1;37m: "
