#!/bin/bash
dir=$(pwd | sed 's/shell//g')


if [[ ! -d /etc/TerminusBot/TBotZap/auth_info_baileys ]]
then
cat << FECHA
========================== 
    GERANDO QR-CODE 
==========================
FECHA
    sleep 3
    clear
    node /etc/TerminusBot/TBotZap/index.js
fi

if [[ -d /etc/TerminusBot/TBotZap/auth_info_baileys ]]
then
    screen -dmS tbotzap 
    screen -S tbotzap -p 0 -X stuff  "node /etc/TerminusBot/TBotZap/TBotZapStart.js\n"

    screen -dmS tbotzapcheck
    screen -S tbotzapcheck -p 0 -X stuff  "bash /etc/TerminusBot/TBotZap_Update.sh\n"
    clear

cat << FECHA
========================== 
        BOT ONLINE 
==========================
FECHA
 sleep 2
 clear

    bash terminus
fi