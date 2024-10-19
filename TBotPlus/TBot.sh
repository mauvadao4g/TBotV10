#!/bin/bash

file=/etc/TermiusBot
file_mp="$file/info-mp"
file_bot="$file/etc/TerminusBot/info-bot"
file_revenda="$file/revenda-link"
file_valor_login="$file/valor-login"
file_temp_teste="$file/tempo-test"
file_temp_conta="$file/tempo-conta"
file_arquivo="$file/arquivo"
db_bloc="$file/usuarios_bloc.db"


#======================== CONSTANTES ======================================|
TOKEN=$(cat /etc/TerminusBot/info-bot)
MP=$(cat /etc/TerminusBot/info-mp)
file_criarteste="$file/criarteste.sh"
file_criarconta="$file/criarusuario.sh"
VALOR=""
ARQUIVO=$(cat /etc/TerminusBot/dir-arquivo)
ARQUIVO_TESTE=$(cat /etc/TerminusBot/tempo-test)
ACESSOS=$(cat /etc/TerminusBot/acessos)
#==========================================================================|

MESSAGE=""
CHAT_ID=""
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
update_id=0
FILE_PATH=$(pwd)
#=============================== IMPORTS ===========================================|
[[ -f /etc/TerminusBot/conta_teste.sh ]] && source /etc/TerminusBot/conta_teste.sh

handler_bot(){

  result=$(curl -s  --request POST \
     --url https://api.telegram.org/bot$TOKEN/getUpdates \
     --header 'Accept: application/json' \
     --header 'Content-Type: application/json' \
     --data '
{
     "offset": -1,
     "limit": 1,
     "timeout": 5
}
')
  conexao=$(echo $result | jq -r '.result[-1]')

  if [ -n "$conexao" ]
  then
    
    MESSAGE=$result
    update_id=$( echo $MESSAGE | jq -r '.result[-1].update_id')
    MESSAGE_ID=$(echo $MESSAGE | jq -r '.result[-1].message_id')


        #CHAT_ID=$(echo $MESSAGE | jq -r 'result[-1].message.from.id')
        
        CHAT_ID=$(echo $MESSAGE | jq -r '.result[-1].message.from.id')
        
    
  fi
    #CHAT_ID=$(echo $result | jq -r 'result[-1].message.from.id
}

send_file(){
  curl -v -F "chat_id=$1" -F document="@/root/$ARQUIVO" "https://api.telegram.org/bot$TOKEN/sendDocument"

  
}

mainMenu(){

segundo_botao=""
valor_formatado=$(echo "$VALOR" | sed 's/\./,/')

link_suporte=$(cat /etc/TerminusBot/link_suporte)
link_revenda=$(cat /etc/TerminusBot/revenda-link)
 [[ -z $link_suporte ]] && link_suporte="https://www.google.com/"
 [[ -z $link_revenda ]] && link_revenda="https://www.google.com/"

  if [[ $menu_estendido == "ativo" ]]
  then

	segundo_botao=',[
    		{
        	"text": "〘 LOGIN: R$'${segundo_valor}' | VÁLIDADE: '${tempo_segundo_valor}'- DIAS 〙",
        	"callback_data": "Segundo"
      		}

    	]'
  fi

	replay_markup='{
	"inline_keyboard": [
    	[
      		{
        	"text": "COMPRAR ACESSO SSH",
        	"callback_data": "comprar"
      		}
    	],
    	[
        	{
        	"text": "CRIAR TESTE GRÁTIS",
        "callback_data": "Teste"
      }
   ],
   [
      {
            "text": "SEJA REVENDEDOR",
            "callback_data": "Revender",
            "url": "'${link_revenda}'"
          }

    ],
    [
    {
        "text": "SUPORTE AO CLIENTE",
        "callback_data": "suporte",
        "url": "'${link_suporte}'"
      }

    ]
  ]
}'




curl -s -X POST $URL -d chat_id=$CHAT_ID  -d text="
Olá <b>$1</b>, Bem vindo! Como posso te ajudar?

✅ /start - Inicia o menu

✅ Comprar acesso VPN - Compre seu acesso para  ${duracao_login}

✅ Criar teste Grátis - Você só pode criar 1 teste a cada 24 horas.

✅ Suporte ao Cliente - Entre em contato conosco!

✅ Download Aplicativo - Baixa nosso Aplicativo da Play Store.

✅ Baixar arquivo de conexão 

📍 SEMPRE REALIZE UM TESTE ANTES DA CONTRATAÇÃO!
QUALQUER DúVIDA FICAREMOS FELIZES EM SANAR."   -d parse_mode="HTML"  -d reply_markup="$replay_markup"

}

menu_compra_um(){
  usuarios_primeiro=`cat /etc/TerminusBot/acessos`
  duracao_login=$(cat /etc/TerminusBot/tempo-conta)
  valor_login_um=$(cat /etc/TerminusBot/valor-login)
   
   [[ $usuarios_primeiro > 1 ]] && {
    plural="pessoas"
  } || {
    plural="pessoa"
  }

	new_markup='{
	"inline_keyboard": [
     [
      		{
        	"text": " COMPRAR ACESSO SSH ",
        	"callback_data": "comprar_um"
      		}
    ],
    [
      		{
        	"text": " CANCELAR COMPRA ",
        	"callback_data": "cancelar"
      		}
    ]
  ]
}'

curl -s -X POST $URL -d chat_id=$CHAT_ID  -d text="
📌  DETALHES DA COMPRA 📌

👜 <b>PRODUTO:</b> ACESSO VPN

💰 <b>PREÇO:</b> ${valor_login_um} Reais

📅 <b>VALIDADE:</b> ${duracao_login} Dias

👤 <b> USUÁRIOS: </b> ${usuarios_primeiro} ${plural}
"   -d reply_markup="$new_markup" -d parse_mode="HTML"

}

menu_compra_dois(){

  tempo_segundo_valor=$(cat /etc/TerminusBot/tempo_segundo_valor)
  segundo_valor=$(cat  /etc/TerminusBot/segundo_valor)
  usuarios_segundo=$(cat /etc/TerminusBot/usuario_segundo_login)
  [[ $usuarios_segundo > 1 ]] && {
    plural="pessoas"
  } || {
    plural="pessoa"
  }
	new_markup='{
	"inline_keyboard": [
     [
      		{
        	"text": " COMPRAR ACESSO SSH ",
        	"callback_data": "comprar_dois"
      		}
    ],
    [
      		{
        	"text": " CANCELAR COMPRA ",
        	"callback_data": "cancelar"
      		}
    ]
  ]
}'

curl -s -X POST $URL -d chat_id=$CHAT_ID  -d text="
📌  DETALHES DA COMPRA 📌

👜 <b>PRODUTO:</b> ACESSO VPN

💰 <b>PREÇO:</b> ${segundo_valor} Reais

📅 <b>VALIDADE:</b> ${tempo_segundo_valor} Dias

👤 <b> USUÁRIOS: </b> ${usuarios_segundo} ${plural}
"   -d reply_markup="$new_markup" -d parse_mode="HTML"


}


sendPixCode(){

  payment_result=$(pagamento $1)
  if [[ -n $payment_result ]]
  then
    paymentID=$(echo $payment_result | jq -r '.id')
    code=$(echo $payment_result | jq -r    '.point_of_interaction.transaction_data.qr_code')
    base64=$(echo $payment_result | jq -r    '.point_of_interaction.transaction_data.qr_code_base64')
    echo $payment_result

    inserir="$paymentID|pending|$1|$2|$3|$4"
    echo -e "$inserir" >> .pedidos.db
  
    curl -s -X POST $URL -d chat_id=$2  -d text="✅ O código de pagamento foi gerado, toque nele para copiar." d parse_mode="HTML"
        
    curl -s -X POST $URL -d chat_id="$2"  -d text="\`$code\`" -d parse_mode="MarkDown" 

    curl -s -X POST $URL -d chat_id=$2 -d text="⏳ Assim que recebermos a confirmação do pagamento enviaremos a sua conta automaticamente." -d parse_mode="HTML"

 
  else
    curl -s -X POST $URL -d chat_id="$2"  -d text="😓 Oh, não! Estamos enfrentando um problema contacte o meu adminstrador." -d parse_mode="HTML" 
  fi
}

pagamento(){
 
   local transaction_request=$(
    curl -X POST \
    --url https://api.mercadopago.com/v1/payments \
    --header 'accept: application/json' \
    --header 'content-type: application/json' \
    --header 'Authorization: Bearer '$MP \
    --data '{
      "transaction_amount": '$1',
      "description": "Título do produto",
      "payment_method_id": "pix",
      "payer": {
        "email": "test@test.com",
        "first_name": "Test",
        "last_name": "User",
        "identification": {
            "type": "CPF",
            "number": "19119119100"
        },
        "address": {
            "zip_code": "06233200",
            "street_name": "Av. das Nações Unidas",
            "street_number": "3003",
            "neighborhood": "Bonfim",
            "city": "Osasco",
            "federal_unit": "SP"
        }
      }
    }'
  )
   echo $transaction_request



}



from_id=0
mensagensIDs=""
contadorMensagens=0
NEXT_MESSAGE=0
CALLBACK=0
NEW_UPDATE=0
main(){
  while :
  do
    handler_bot
    if [ $update_id != $NEW_UPDATE ]
    then

      MESSAGE_ID=$(echo $MESSAGE | jq -r '.result[-1].message.message_id')
  
           if [  $(echo $MESSAGE | jq -r '.result[-1].message.text')  == "/start" ];
           then
               user=$(echo $MESSAGE | jq -r '.result[-1].message.from.username')
                
                 NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id') 
                 mainMenu "$user"
                 NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
           
          fi
     fi
      
      
      if [ $(echo $MESSAGE | jq -r '.result[-1].callback_query.data') ]
      then

        if [ $update_id != $NEW_UPDATE ]
        then
          if [  $( echo $MESSAGE | jq -r '.result[-1].callback_query.data') == "Teste" ];
          then
             
                NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
                CHAT_ID=$(echo $MESSAGE | jq -r '.result[-1].callback_query.from.id')
                /etc/TerminusBot/./conta_teste.sh $CHAT_ID                
                NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
           fi
        fi


        if [ $update_id != $NEW_UPDATE ]
        then
              if [  $( echo $MESSAGE | jq -r '.result[-1].callback_query.data') == "comprar" ]
                 then
                    CHAT_ID=$(echo $MESSAGE | jq -r '.result[-1].callback_query.from.id')
                    menu_compra_um
                   
                    NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
                    [[ `cat /etc/TerminusBot/menu_extendido` == "ativo" ]] && {
        
                      menu_compra_dois
                      
                      NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
                    }
                    
              fi
              

        fi
        
        if [[ -n `echo $MESSAGE | jq -r '.result[-1]'` ]]
        then
          
          if [ $update_id != $NEW_UPDATE ]
          then
            if [  $( echo $MESSAGE | jq -r '.result[-1].callback_query.data') == "cancelar" ]
            then
                    #curl -s POST "https://api.telegram.org/bot$TOKEN/deleteMessage"  -d chat_id=$CHAT_ID -d message_id=$ids
                   echo "=========== CANCELAR ================"
                   echo $MESSAGE | jq -r '.result[-1].callback_query.message.message_id'
                   [[ -n `echo $MESSAGE | jq -r '.result[-1].callback_query.message.message_id'` ]] && {
                      ids=`echo $MESSAGE | jq -r '.result[-1].callback_query.message.message_id'`
                      CHAT_ID=$(echo $MESSAGE | jq -r '.result[-1].callback_query.from.id')
                      curl -s POST "https://api.telegram.org/bot$TOKEN/deleteMessage"  -d chat_id=$CHAT_ID -d message_id=$ids
                   }
            fi
          fi

        fi


          if [ $update_id != $NEW_UPDATE ]
          then
            if [  $( echo $MESSAGE | jq -r '.result[-1].callback_query.data') == "comprar_um" ]
            then
              NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
              primeiro_valor=$(cat /etc/TerminusBot/valor-login)
              usuarios_primeiro=`cat /etc/TerminusBot/acessos`
              duracao_login=$(cat /etc/TerminusBot/tempo-conta)
              CHAT_ID=$(echo $MESSAGE | jq -r '.result[-1].callback_query.from.id')
              sendPixCode $primeiro_valor $CHAT_ID $usuarios_primeiro $duracao_login
              NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
            fi
          fi


         if [ $update_id != $NEW_UPDATE ]
          then
            if [  $( echo $MESSAGE | jq -r '.result[-1].callback_query.data') == "comprar_dois" ]
            then
              NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
              segundo_valor=$(cat  /etc/TerminusBot/segundo_valor)
              CHAT_ID=$(echo $MESSAGE | jq -r '.result[-1].callback_query.from.id')
              tempo_segundo_valor=$(cat /etc/TerminusBot/tempo_segundo_valor)
              segundo_valor=$(cat  /etc/TerminusBot/segundo_valor)
              usuarios_segundo=$(cat /etc/TerminusBot/usuario_segundo_login)
              sendPixCode  $segundo_valor $CHAT_ID $usuarios_segundo $tempo_segundo_valor
              NEW_UPDATE=$(echo $MESSAGE | jq -r '.result[-1].update_id')
            fi
          fi

     fi
  
done
 
}


main
