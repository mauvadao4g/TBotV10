#!/bin/bash



TBotZap.payment(){

    local resultado=$(
    curl -s -X GET \
        'https://api.mercadopago.com/v1/payments/'$1 \
        -H 'Authorization: Bearer '$(cat /etc/TerminusBot/info-mp)
    )

 echo $resultado

}

TBotZap.update(){
if [[ -f /etc/TerminusBot/TBotZap/usuarios/pedidos.json ]]
  then
  
    while :
    do

         database=$(cat /etc/TerminusBot/TBotZap/usuarios/pedidos.json | jq '.[]')
        total=$(cat /etc/TerminusBot/TBotZap/usuarios/pedidos.json | jq '. | length')
        result=$(echo  $database | jq 'select(.status == "pending")')
        if [[ -n $result ]]
        then
            id=$(echo $result | jq '.order_id')
            for i in $id; do
                pagamento_status=$(TBotZap.payment $i)
                current_status=$(echo $pagamento_status | jq -r '.status')
                if [[ $current_status == "approved" ]]
                then
                       
                        
                    user=$(echo  $database | jq 'select(.order_id == '$i')')
                    chat_id=$(echo $user  | jq -r '.chat_id')
                    node /etc/TerminusBot/TBotZap/TBotZap_Update.js $chat_id $i
                    echo "MENSAGEM ENVIADA E SCRIPT FINALIZADO"
                    
                fi
            done
        fi
        

    done
  fi
}

TBotZap.update