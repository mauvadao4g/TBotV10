#!/bin/bash

criar_teste(){
  TOKEN=$(cat /etc/TerminusBot/info-bot)
  URL="https://api.telegram.org/bot$TOKEN/sendMessage"

  lista=$(awk -F\|n '{print}' /etc/TerminusBot/usuarios_bloc.db)
  n=0

  for id in $lista;do
    if [ $1 == $id ]
    then
      n=1
    fi
  done

  if [ $n == 0 ]
  then
    chmod +x /etc/TerminusBot/criarteste.sh
    echo $1 >> /etc/TerminusBot/usuarios_bloc.db
    /etc/TerminusBot/./criarteste.sh $1  
   else
    curl -s -X POST $URL -d chat_id=$1  -d text="<b>Você já recebeu seu teste grátis</b>" -d parse_mode="HTML"  
  fi

}

criar_teste $1
