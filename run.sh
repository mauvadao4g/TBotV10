#!/bin/bash
# MAUVADAO
# VER: 1.0.0

#================ CODIGOS ESTILOS ============|
Bold=$(tput bold)
Norm=$(tput sgr0)
Yellow=$(tput setaf 3)
Red=$(tput setaf 1)
Green=$(tput setaf 2)

if [ "$EUID" -ne 0 ]
then
    clear
    echo "${Red}[!] Por favor, rode o script como root${Norm}"
    exit
fi

# Entrar na pasta principal pra copiar os arquivos
[[ ! -d TBotPlus ]] && { echo '\e[1;31mPasta não existe: TBotPlus\e[0m'; exit 1; } || cd TBotPlus



alocar_bot(){

    mv TerminusBot.sh terminus
    chmod +x terminus
    cp terminus /bin
    mv terminus TerminusBot.sh
    chmod +x TerminusBot.sh

}

# bash TBotPlus/progress&
bash progress&
PID=$!
alocar_bot
cp -rf ./* /etc/TerminusBot/
# rm -r TBotPlus # apaga a pasta  TBotPlus
clear
$(kill $PID)
clear
echo "[-] Para iniciar o menu na proxima vez digite: ${Yellow}\"terminus\"${Norm}"
sleep 5

terminus

