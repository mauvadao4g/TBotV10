#!/bin/bash
#pagamentoId=$1

# Recebe o paymentId do pagamento.db verifica todos os paymentId com o status
# pending e acessa a 

#if [[ $UID -ne 0 ]]; then
#	echo Execute $0 como root
#	exit 1
#fi

#=============== CONSTANTES =============#
mp_token=$(cat /etc/TerminusBot/info-mp)
#========================================|
verifica_pagamento(){  

local resultado=$(
  curl -s -X GET \
    'https://api.mercadopago.com/v1/payments/'$1 \
    -H 'Authorization: Bearer '$mp_token 
)

 echo $resultado
}


busca_pendente(){
lista=$(cat .pedidos.db)
if [[ -n $lista ]]
then

  for linha in $lista; do
    payment=$(echo $linha | cut -d"|" -f 1)
    status=$(echo $linha | cut -d"|" -f 2)
    value=$(echo $linha | cut -d"|" -f 3)
    chatId=$(echo $linha | cut -d"|" -f 4)
    limit=$(echo $linha | cut -d"|" -f 5)
    expire=$(echo $linha | cut -d"|" -f 6)
    
   

    if [[ $status != "approved" ]]
    then
    
      pagamento_status=$(verifica_pagamento $payment)
      current_status=$(echo $pagamento_status | jq -r '.status')
      if [[ $current_status == "approved" ]]
      then
        
        current_status=$(echo $pagamento_status | jq -r '.status')
	      valor=$(echo $pagamento_status | jq -r '.transaction_amount')
	      sed -i 's/'$linha'/'$payment'|approved|'$valor'|'$chatId'|'$expire'|'$limit'/g' .pedidos.db
	      sendFile=$payment'|approved|'$valor'|'$chatId'|'$expire'|'$limit
	      bash /etc/TerminusBot/criarusuario.sh $sendFile

      fi
    fi

  done
fi

}

while :
do
  busca_pendente
  sleep 10
done
