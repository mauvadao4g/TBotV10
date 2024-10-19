#!/bin/bash
#=========HEADER===========================================================|
#
#==========================================================================|

[[ -f /etc/TerminusBot/link_download.sh ]] && source /etc/TerminusBot/link_download.sh
[[ ! -d "/etc/TerminusBot/" ]] && mkdir -p '/etc/TerminusBot/'
[[ ! -f "/etc/TerminusBot/info-bot" ]] && touch '/etc/TerminusBot/info-bot'


#================ CODIGOS ESTILOS ============|
Bold=$(tput bold)
Norm=$(tput sgr0)
Yellow=$(tput setaf 3)
Red=$(tput setaf 1)
Green=$(tput setaf 2)
#=============== CONSTANTES =============#
file=/etc/TermiusBot
file_mp="$file/info-mp"
file_bot="$file/etc/TerminusBot/info-bot"
file_revenda="$file/revenda-link"
file_valor_login="$file/valor-login"
file_temp_teste="$file/tempo-test"
file_temp_conta="$file/tempo-conta"
file_usuarios_bloc="$file/usuarios_bloc.db"
file_arquivo="$file/arquivo"
file_db_pedidos="$file/pedidos.db"


if [[ $UID -ne 0 ]]; then
	echo Execute $0 como root
	exit 1
fi




banner(){
clear
#============================== COLUNA 1 ================================================|
tput cup 3 1
tput setab 7 
tput setaf 0
echo "                            CIBORGUE BOT  V1.0                               "
tput sgr0
echo " "
tput cup 4 1
echo "${Red}[${Norm}${Bold}1${Norm}${Red}]${Norm} ${Yellow}${Bold}Ativar Bot Telegram${Norm}${Norm}[${Green}${terminus_vazio}${Norm}]"        
tput sgr0     
tput cup 5 1
echo "${Red}[${Norm}${Bold}2${Norm}${Red}]${Norm} ${Yellow}${Bold}Ativar Bot WhatsApp${Norm}${Norm}[${Green}${twabot_vazio}${Norm}]"        
tput sgr0     
tput cup 6 1
echo "${Red}[${Norm}${Bold}3${Norm}${Red}]${Norm} ${Yellow}${Bold}Parar Telegram${Norm}${Norm}"       
tput sgr0
tput cup 7 1
echo "${Red}[${Norm}${Bold}4${Norm}${Red}]${Norm} ${Yellow}${Bold}Parar WhatsApp${Norm}${Norm}"       
tput sgr0
tput cup 8 1
echo "${Red}[${Norm}${Bold}5${Norm}${Red}]${Norm} ${Yellow}${Bold}Token bot${Norm}${Norm} [${Green}${bot_vazio}${Norm}]"
tput sgr0
tput cup 9 1
echo "${Red}[${Norm}${Bold}6${Norm}${Red}]${Norm} ${Yellow}${Bold}Token MercadoPago${Norm}${Norm} [${Green}${mp_vazio}${Norm}]"
tput sgr0
tput cup 10 1
echo "${Red}[${Norm}${Bold}7${Norm}${Red}]${Norm} ${Yellow}${Bold}Editar link Revenda${Norm}${Norm} [${Green}${revenda_vazio}${Norm}]" 
tput sgr0
tput cup 11 1
echo "${Red}[${Norm}${Bold}8${Norm}${Red}]${Norm} ${Yellow}${Bold}Link de suporte ao cliente${Norm}${Norm} [${Green}${suporte_vazio}${Norm}]"   
tput sgr0
tput cup 12 1
echo "${Red}[${Norm}${Bold}9${Norm}${Red}]${Norm} ${Yellow}${Bold}Adicionar Link Download${Norm}${Norm} [${Green}${link_vazio}${Norm}]"   
tput sgr0


#================================== COLUNA 2 ================================================|
tput cup 4 36
echo "${Red}[${Norm}10${Red}]${Norm} ${Yellow}${Bold}Validade da 1° Conta${Norm}${Norm} [${Green}${validade_conta_vazio}${Norm}]"  
tput sgr 0
tput cup 5 36
echo "${Red}[${Bold}${Norm}11${Red}]${Norm} ${Yellow}${Bold}Tempo para conta Teste${Norm}${Norm} [${Green}${test_vazio}${Norm}]"
tput sgr0
tput cup 6 36
echo "${Red}[${Norm}${Bold}12${Norm}${Red}]${Norm} ${Yellow}${Bold}Valor da 1° Conta${Norm}${Norm} [${Green}${valor_vazio}${Norm}]"
tput sgr0
tput cup 7 36
echo "${Red}[${Norm}${Bold}13${Norm}${Red}]${Norm} ${Yellow}${Bold}Número de acessos 1° Conta${Norm}${Norm} [${Green}${acesso_vazio}${Norm}]"
tput sgr0
tput cup 8 36
echo "${Red}[${Norm}${Bold}14${Norm}${Red}]${Norm} ${Yellow}${Bold}Adicionar/Remover - Segunda conta${Norm}${Norm} [${Green}${extendido_vazio}${Norm}]"
tput sgr0
tput cup 9 36
echo "${Red}[${Norm}${Bold}15${Norm}${Red}]${Norm} ${Yellow}${Bold}Excluir Bot${Norm}${Norm}"
tput sgr0
tput cup 10 36
echo "${Red}[${Norm}${Bold}16${Norm}${Red}]${Norm} ${Yellow}${Bold}Mostrar erro${Norm}${Norm}"
tput sgr0
tput cup 11 36
echo "${Red}[${Norm}${Bold}00${Norm}${Red}]${Norm} ${Yellow}${Bold}Sair${Norm}${Norm}"
tput sgr0

}


menu_principal(){

[[ -z $(cat /etc/TerminusBot/link_mediafire ) ]] || [[ -z $(cat /etc/TerminusBot/link_playstore ) ]] && {
  link_vazio=""
} || {
  link_vazio="ok"
}

if [[ -f /etc/TerminusBot/info-mp ]]
then
   [[ -z $(cat /etc/TerminusBot/info-mp) ]] && mp_vazio="" || mp_vazio="ok" 
fi 

if [[ -f /etc/TerminusBot/tempo-test ]]
then
   [[ -z $(cat /etc/TerminusBot/tempo-test) ]] && test_vazio="" || test_vazio="ok" 
fi 

if [[ -f /etc/TerminusBot/valor-login ]]
then
   [[ -z $(cat /etc/TerminusBot/valor-login) ]] && valor_vazio="" || valor_vazio="ok" 
fi

if [[ -f /etc/TerminusBot/tempo-conta ]]
then
   [[ -z $(cat /etc/TerminusBot/tempo-conta) ]] && validade_conta_vazio="" || validade_conta_vazio="ok" 
fi

if [[ -f /etc/TerminusBot/revenda-link ]]
then
   [[ -z $(cat /etc/TerminusBot/revenda-link ) ]] && revenda_vazio="" || revenda_vazio="ok" 
fi

if [[ -f /etc/TerminusBot/dir-arquivo ]]
then
   [[ -z $(cat /etc/TerminusBot/dir-arquivo ) ]] && arquivo_vazio="" || arquivo_vazio="ok" 
fi

if [[ -f /etc/TerminusBot/info-bot ]]
then
   [[ -z $(cat /etc/TerminusBot/info-bot ) ]] && bot_vazio="" || bot_vazio="ok" 
fi

if [[ -f /etc/TerminusBot/acessos ]]
then
  [[ -z $(cat /etc/TerminusBot/acessos ) ]] && acesso_vazio="" || acesso_vazio="ok" 
fi

if [[ -f /etc/TerminusBot/menu_extendido ]]
then
  [[ -z $( cat /etc/TerminusBot/menu_extendido) ]] && extendido_vazio="" || extendido_vazio="ok"
fi

if [[ -f /etc/TerminusBot/segundo_valor ]]
then
  [[ -z $( cat /etc/TerminusBot/segundo_valor) ]] && segundo_valor_vazio="" || segundo_valor_vazio="ok"
fi


if [[ -f /etc/TerminusBot/tempo_segundo_valor ]]
then
  [[ -z $( cat /etc/TerminusBot/tempo_segundo_valor) ]] && validade_segundo_vazio="" || validade_segundo_vazio="ok"
fi

if [[ -f /etc/TerminusBot/link_app_download ]]
then
  [[ -z $( cat /etc/TerminusBot/link_app_download) ]] && link_download="" || link_download="ok"
fi

if [[ -n $( screen -ls | grep tbotzap ) ]]
then
  twabot_vazio="ok"
fi

if [[ -n $( screen -ls | grep terminus ) ]]
then
  terminus_vazio="ok"
fi

if [[ -f /etc/TerminusBot/link_suporte ]]
then
 [[ -z $( cat /etc/TerminusBot/link_suporte) ]] && suporte_vazio="" || suporte_vazio="ok"
fi
banner

echo -e "\n"
    read -p "Escolha uma opção: " INPUT_STRING

    case $INPUT_STRING in
	    1 )
		ativar_bot_telegram
		;;
      2 )
      ativar_bot_WhatsApp
      ;;
	    3 )
      clear
      pararBot_telegram
		  
		      ;;
      4 )
      clear
      pararBot_whatsapp
      ;;
      5 )
        clear
        pedir_token_bot
        
          ;;
      6 )
        clear
        pedir_token_mp
        
          ;;
      7 ) 
        clear
        link_revenda
          ;;
      8 ) 
        clear
        link_suporte
          ;;
      9 ) 
        clear
        menu_app_download
        exit 1
          ;;
      10 )
        clear
        validade_conta
          ;;
      11 )
        clear
        tempo_teste
          ;;
      12 )
        clear
        valor_login
          ;;
      13 )
        clear
        numero_acesso
        ;;
      14  )
        clear
        segundo_menu
          ;;
      15  )
        clear
        excluir_bot
          ;;
      16  )
        clear
        show_error
          ;;

      00 )
        clear
        fechar

          ;;
  esac
}
#============= FUNÇÕES ===============#
tempo_teste(){
   while :
  do

  echo "${Yellow}${Bold}Digite  o tempo de duração${Norm}${Norm}"
  echo "${Magenta}Ex: 60 = [1] Hora | 120 = [2] Horas${Norm}"
  read -p ":>" validade

    if [[ -z $(echo $validade | egrep '[0-9]{0,}' ) ]]
    then
      echo "${Red}Digite um valor válido.${Norm}"
      sleep 2
      clear
    else
      echo $validade > /etc/TerminusBot/tempo-test
      clear
      echo "${Green}[-] Tempo salvo com sucesso!${Norm}"
      sleep 2
      clear
      menu_principal
      break
    fi

  done
}

segundo_menu(){

  if [[ -f /etc/TerminusBot/menu_extendido ]]
  then
    [[ -z $( cat /etc/TerminusBot/menu_extendido) ]] && extendido_vazio="" || extendido_vazio="ok"
  fi

  if [[ -f /etc/TerminusBot/segundo_valor ]]
  then
    [[ -z $( cat /etc/TerminusBot/segundo_valor) ]] && segundo_valor_vazio="" || segundo_valor_vazio="ok"
  fi


  if [[ -f /etc/TerminusBot/tempo_segundo_valor ]]
  then
    [[ -z $( cat /etc/TerminusBot/tempo_segundo_valor) ]] && validade_segundo_vazio="" || validade_segundo_vazio="ok"
  fi

  if [[ -f /etc/TerminusBot/usuario_segundo_login ]]
  then
    [[ -z $( cat /etc/TerminusBot/usuario_segundo_login ) ]] && acesso_segundo_vazio="" || acesso_segundo_vazio="ok"
  fi

  tput cup 3 1
  tput setab 7
  tput setaf 0
  echo "               Segundo botão                                  "
  tput sgr0

  tput cup 4 1
  echo "${Red}[${Norm}${Bold}1${Norm}${Red}]${Norm} ${Yellow}${Bold}Ativar/Desativar segunda conta${Norm}${Norm} [${Green}${extendido_vazio}${Norm}]"        
  tput sgr0
  tput cup 5 1
  echo "${Bold}${Red}[${Norm}2${Red}]${Norm} ${Yellow}${Bold}Valor 2° conta${Norm}${Norm} [${Green}${segundo_valor_vazio}${Norm}]"       
  tput sgr0
  tput cup 6 1
  echo "${Bold}${Red}[${Norm}3${Red}]${Norm} ${Yellow}${Bold}Validade 3° conta${Norm}${Norm} [${Green}${validade_segundo_vazio}${Norm}]"       
  tput sgr0
  tput cup 7 1
  echo "${Bold}${Red}[${Norm}4${Red}]${Norm} ${Yellow}${Bold}Número de acesso${Norm}${Norm} [${Green}${acesso_segundo_vazio}${Norm}]"       
  tput sgr0

  tput cup 8 1
  echo "${Bold}${Red}[${Norm}5${Red}]${Norm} ${Yellow}${Bold}Voltar${Norm}${Norm}"       
  tput sgr0
  configuracao
}

show_error(){
    if [[ $( screen -ls | egrep -c [0-9]+\.tbotzap[^check]) ]]
    then
     screen -r $(egrep -o [0-9]+\.tbotzap[^check])
    fi
}
configuracao(){
  while :
 do
    echo -e "\n"
    read -p "Escolha:> " escolha
    if [[ $escolha == "1" ]] 
    then

      [[  $(cat /etc/TerminusBot/menu_extendido) == "ativo" ]] && {
        echo "" > /etc/TerminusBot/menu_extendido
        echo "" > /etc/TerminusBot/tempo_segundo_valor
        echo "" > /etc/TerminusBot/segundo_valor

        echo "${Green}[-] Segundo botão desativado com sucesso!"
        sleep 2
        clear
        segundo_menu
        break
      } || {
        echo "ativo" > /etc/TerminusBot/menu_extendido
        clear
        segundo_menu
        break
      }

    fi
    if [[ $escolha == "2" ]] 
    then
      valor_segundo_login 
      break 
    fi
    if [[ $escolha == "3" ]]
    then
      tempo_segundo_login 
      break 
    fi
    if [[ $escolha == "4" ]]
    then
      usuario_segundo_login
      break
    fi
    if [[ $escolha == "5" ]]
    then
      menu_principal
      break
    fi
 done
}

#========================= LINK SUPORTE / REVENDA ===============================
link_suporte(){
   while :
  do

  echo "${Yellow}${Bold}[-] Digite um link de contato${Norm}${Norm}"
  echo "${Yellow}${Bold}[-] O link pode ser do telegram ou um site${Norm}${Norm}"
  echo "${Cyan}Ex: https//:t.me/oogeniohacker${Norm}"
  read -p ":> " link

    if [[ -z $(echo $link | egrep '^https://' ) ]]
    then
      echo "${Red}[!] Digite uma url válida${Norm}"
      sleep 2
      clear
    else
      echo $link > /etc/TerminusBot/link_suporte
      echo "${Green}[-] Link salvo com sucesso!${Norm}"
      sleep 2
      clear
      menu_principal
      break
    fi

  done
}

link_revenda(){
  while :
  do

  echo "${Yellow}${Bold}[-] Digite um link de contato${Norm}${Norm}"
  echo "${Yellow}${Bold}[-] O link pode ser do telegram ou um site${Norm}${Norm}"
  echo "${Cyan}Ex: https//:t.me/renato_office${Norm}"
  read -p ":> " link

    if [[ -z $(echo $link | egrep '^https://' ) ]]
    then
      echo "${Red}[!] Digite uma url válida${Norm}"
      sleep 2
      clear
    else
      echo $link > /etc/TerminusBot/revenda-link
      echo "${Green}[-] Link salvo com sucesso!${Norm}"
      sleep 2
      clear
      menu_principal
      break
    fi

  done
}

#====================================================================================#


valor_segundo_login(){

 while :
 do
  clear
  echo "${Yellow}${Bold}[-] Digite um valor para sua conta${Norm}${Norm}"
  echo "${Yellow}${Bold}[-] Esse falor vai será pago pelo client${Norm}${Norm}"
  echo "${Cyan}Ex: 10.00${Norm}"
  read -p ":>" valor

  if [[ -z $(echo $valor | egrep '[0-9]{1,}.[0-9]' ) ]]
  then
      echo "${Red}[!]Digite um valor válido${Norm}"
      sleep 1
      clear
   else
      echo $valor > /etc/TerminusBot/segundo_valor
      clear
      echo "${Green}[-] Valor salvo com sucesso!${Norm}"
      sleep 2
      clear
      segundo_menu
      break
   fi
done

}


tempo_segundo_login(){
   clear
  while :
  do
    echo "Digite a validade da conta"
    echo "Ex: 30 = 1 Mês | 60 = 2 Mêses"
    read -p ":> " escolha
   if [[ -n $( echo $escolha | egrep '[0-9]{2,}') ]] 
   then
      echo $escolha > /etc/TerminusBot/tempo_segundo_valor
      clear
      echo "[-] Válidade salva com sucesso!"
      sleep 2
      clear
      segundo_menu
      break
    else
      clear
      echo "${Red}[*] Digite um número válido. ${Norm}"
      sleep 2
      clear
    fi
   

  done

}

usuario_segundo_login(){
   clear
  while :
  do
    echo "${Yello}${Bold}Digite o numero de acesso  a  conta${Norm}${Norm}"
    echo "${Magenta}Ex: 1 = 1 Acesso | 2 = 2 Acesso${Norm}"
    read -p ":> " escolha
   if [[ -n $( echo $escolha | egrep '[0-9]{1,}') ]] 
   then
      echo $escolha > /etc/TerminusBot/usuario_segundo_login
      clear
      echo "${Green}[-] Limite de usuarios salvo com sucesso!${Norm}"
      sleep 2
      clear
      segundo_menu
      break
    else
      clear
      echo "${Red}[*] Digite um número válido. ${Norm}"
      sleep 2
      clear
    fi
   

  done

}


excluir_bot(){
  rm -R /etc/TerminusBot
  rm /bin/terminus
  pararBot_telegram
  pararBot_whatsapp
  exit 1
}

enviar_arquivo(){
while :
      do
        echo "${Yellow}${Bold}[-] Digite o link para  Play Store${Norm}${Norm}"
        read -p ":> " link
        [[ -n $link ]] && {
          echo $link > /etc/TerminusBot/dir-arquivo
          clear
          echo "${Green}${Bold}[-] Link da Play Store foi salvo com sucesso!${Norm}${Norm}"
          sleep 2
          menu_principal
          break
         } || {
           echo "${Red}${Bold}[!] Link vazio! ${Norm}${Norm}"
            sleep 2
            break
         }
      done
      
}

numero_acesso(){
  while :
  do

  echo "${Yellow}${Bold}[-] Digite o numero de usuário simultaneo com acesso a conta.${Norm}${Norm}"
  echo "${Cyan}Ex: 1 = [1] Usuario | 2 = [2] Usuario${Norm}"
  read -p ":>" quantidade

    if [[ -z $(echo $quantidade | egrep '^[0-9]{0,}' ) ]]
    then
      echo "${Red}[!] Digite um valor válido${Norm}"
      sleep 2
      clear
    else
      echo $quantidade > /etc/TerminusBot/acessos
      clear
      echo "${Green}[-] Tempo salvo com sucesso!${Norm}"
      sleep 2
      clear
      menu_principal
      break
    fi

  done
}


validade_conta(){
  while :
  do

  echo "${Yellow}${Bold}[-] Digite  quantos dias o login será válido${Norm}${Norm}"
  echo "${Cyan}Ex: 1 = [1] Dia | 10 = [10] Dias | 20 = [20] Dias${Norm}"
  read -p ":>" validade

    if [[ -z $(echo $validade | egrep '^[0-9]{0,}' ) ]]
    then
      echo "${Red}[!] Digite um valor válido${Norm}"
      sleep 2
      clear
    else
      echo $validade > /etc/TerminusBot/tempo-conta
      clear
      echo "${Green}[-] Tempo salvo com sucesso!${Norm}"
      sleep 2
      clear
      menu_principal
      break
    fi

  done
}

fechar(){
  exit 1
}


valor_login(){
while :
 do

  echo "${Yellow}${Bold}[-] Digite um valor para sua conta${Norm}${Norm}"
  echo "${Yellow}${Bold}[-] Esse falor vai será pago pelo client${Norm}${Norm}"
  echo "${Cyan}Ex: 10.00${Norm}"
  read -p ":>" valor

  if [[ -z $(echo $valor | egrep '[0-9]{1,}.[0-9]' ) ]]
  then
      echo "${Red}[!]Digite um valor válido${Norm}"
      sleep 1
      clear
   else
      echo $valor > /etc/TerminusBot/valor-login
      clear
      echo "${Green}[-] Valor salvo com sucesso!${Norm}"
      sleep 2
      clear
      menu_principal
      break
   fi
done


}

pararBot_telegram(){
  clear
  echo -e "${Magenta}[-] Colocando terminus para dormir${Norm}"
  sleep 2
  terminus=$(screen -ls | grep terminus | awk -F'.' {' print $1 '})
  for id in $terminus; do
     screen -X -S $id quit
  done
   sleep 2
  check=$(screen -ls | grep "check-pg" | awk -F'.' {' print $1 '})
  for id in $check; do
     screen -X -S $id quit
  done
  echo -e "${Magenta}[-] Shii! Nao faca barulho. terminus esta dormindo${Norm}"
  sleep 2
  clear

}


pararBot_whatsapp(){
  clear
  echo -e "${Magenta}[-] Só um momento TBotZap está parando as engrenagens${Norm}"
  sleep 2
 for list in $(screen -ls | egrep -o [0-9]+\.tbotzapcheck); do
    if [[ $(echo $list | egrep -c [0-9]+\.tbotzapcheck) ]]
    then
      screen -X -S $list quit
    fi
  done

  for list in $(screen -ls |  egrep -o [0-9]+\.tbotzap); do
    if [[ $( echo $list |  egrep -c [0-9]+\.tbotzap ) ]]
    then
         screen -X -S $list quit
    fi 
  done



  echo -e "${Magenta}[-] TBotZap está parado${Norm}"
  sleep 2
  clear
}


ativar_bot_WhatsApp(){
  clear
  sleep 2
  if [[ -z $( screen -ls | grep tbozap ) ]]
  then
    bash /etc/TerminusBot/TBotZap/shell/run.sh
    #bash /etc/TerminusBot/task.sh
  fi

}

ativar_bot_telegram(){
  screen -dmS terminus 
  screen -S terminus -p 0 -X stuff  '/etc/TerminusBot/./TBot.sh\n'
  sleep 2
  screen -dmS check-pg
  screen -S check-pg -p 0 -X stuff '/etc/TerminusBot/./verificar-pagamento.sh&\n'

  [[ "$?" == "0" ]] && echo "${Green}[-]Terminus Bot TELEGRAM rodando com sucesso!${Norm}"; sleep 2; clear; menu_principal || echo "${Red}[!]Erro ao rodar Terminus bot. Verifique todas as etapas.${Norm}"
}


pedir_token_mp(){

 while :
 do

  echo -e "${Yellow}${Bold}[-] Digite o token do mercado pagao\n${Magenta}[-]Ex: APP_USR6702162676543402-063018-f604ce2bfa1461cd7876c6fb8fa395a0-484048xxx
${Norm}${Norm}${Norm}"

  read -p ":> " token

  if [[ -z $(echo $token | egrep '^APP_USR|TEST' ) ]]
  then
      echo "${Red}[!] Digite um token válido${Norm}"
      sleep 2
      clear
   else
      clear
      echo $token > /etc/TerminusBot/info-mp
      if [[ $? == "0" ]]
      then
        echo "${Green}[-] Token salvo com sucesso!${Norm}"
        sleep 2
        clear
        menu_principal
        break
      else 
        echo "${Red}[!] Não foi possível salva arquivo.${Norm}"
      fi
   fi
done

}

pedir_token_bot(){

 while :
 do

  echo "${Yellow}${Bold}[-] Digite o token do bot${Norm}${Norm}"
  echo "${Magenta}Ex: 5364826966:AAGfUb1i8HZsEHbHPfUmnxerkbITxxx_XXx ${Norm}"
  read -p ":> " token

  if [[ -z $(echo $token | egrep '^[0-9]{10}:\w+' ) ]]
  then
      echo "${Red}[!] Digite um token válido${Norm}"
      sleep 2
      clear
   else
      clear
      echo $token > /etc/TerminusBot/info-bot
      if [[ $? == "0" ]]
      then
        echo "${Green}[-] Token salvo com sucesso!${Norm}"
        sleep 2
        clear
        menu_principal
      else 
        echo "${Red}[!] Não foi possível salva arquivo.${Norm}"
      fi
   fi
done

}

#========================== BAIXANDO DEPENDENCIAS ========================================|

baixar_dependencias(){
  echo "${Yellow}[-] Verificando dependencias ${Norm}"
  sleep 2
  
  [[ -z `type -p git` ]]    &&    apt install git    -y
  [[ -z `type -p screen` ]] &&    apt install screen -y 
  [[ -z `type -p zip` ]]    &&    apt install zip -y    
  [[ -z `type -p jq` ]]     &&    apt install jq -y   
    
  if [[ -d /etc/TerminusBot/TBotZap ]]
  then
    search_node=$(which node)
    echo "${Yellow}[-] Verificando se node está instalado${Norm}"
    sleep 2
    echo "${Yellow}[-] Atualizando nodejs${Norm}"
    sleep 2
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
    source ~/.profile
    nvm install 16
    nvm use 16
    clear
    echo "${Gree}[-] Nodejs já está em sua última versão${Norm}"  
    sleep 2
    clear

  fi
}

#=========================================================================================|

#========================== CRIAR DIRETORIOS E ARQUIVOS ==================================|

criar_arquivos(){

  [[ ! -d /etc/TerminusBot ]] && mkdir /etc/TerminusBot
 
  [[ ! -f /etc/TerminusBot/TBotZap_Update.sh ]] && [[ -f TBotZap_Update.sh ]] && cp TBotZap_Update.sh /etc/TerminusBot/
  [[ ! -f /etc/TerminusBot/verificar-pagamento.sh ]] && [[  -f verificar-pagamento.sh ]] && cp verificar-pagamento.sh /etc/TerminusBot/
  [[ ! -f /etc/TerminusBot/criarusuario.sh ]] && [[ -f criarusuario.sh ]] && cp  criarusuario.sh /etc/TerminusBot/
  [[ ! -f /etc/TerminusBot/criarteste.sh ]] &&  [[ -f criarteste.sh  ]] && cp criarteste.sh /etc/TerminusBot/
  [[ ! -d /etc/TerminusBot/TBotZap ]]  && cp -R ./TBotZap /etc/TerminusBot/
  [[ ! -f /etc/TerminusBot/conta_teste.sh ]] &&  [[ -f conta_teste.sh  ]] && cp conta_teste.sh /etc/TerminusBot/
  [[ ! -f /etc/TerminusBot/TBot.sh ]] &&  [[ -f TBot.sh  ]] && cp TBot.sh /etc/TerminusBot/
  [[ ! -f /etc/TerminusBot/link_download.sh ]] && [[ -f link_download.sh ]]  && cp link_download.sh /etc/TerminusBot
  [[ ! -d /etc/TerminusBot/TBotZap/usuarios ]] && mkdir /etc/TerminusBot/TBotZap/usuarios

  [[ ! -f /etc/TerminusBot/info-mp  ]] && touch /etc/TerminusBot/info-mp
  [[ ! -f /etc/TerminusBot/info-bot ]] && touch /etc/TerminusBot/info-bot
  [[ ! -f /etc/TerminusBot/acessos ]] && touch /etc/TerminusBot/acessos
  [[ ! -f /etc/TerminusBot/valor-login ]] && touch /etc/TerminusBot/valor-login
  [[ ! -f /etc/TerminusBot/tempo-test  ]] && touch /etc/TerminusBot/tempo-test
  [[ ! -f /etc/TerminusBot/tempo_conta  ]] && touch /etc/TerminusBot/tempo-conta
  [[ ! -f /etc/TerminusBot/dir-arquivo ]] && touch /etc/TerminusBot/dir-arquivo
  [[ ! -f /etc/TerminusBot/usuarios.db ]] && touch  /etc/TerminusBot/usuarios.db	
  [[ ! -f /etc/TerminusBot/usuarios_bloc.db ]] && touch /etc/TerminusBot/usuarios_bloc.db
  [[ ! -f /etc/TerminusBot/menu_extendido ]] && touch /etc/TerminusBot/menu_extendido
  [[ ! -f /etc/TerminusBot/segundo_valor ]] && touch /etc/TerminusBot/segundo_valor
  [[ ! -f /etc/TerminusBot/tempo_segundo_valor ]] && touch /etc/TerminusBot/tempo_segundo_valor
  [[ ! -f /etc/TerminusBot/usuario_segundo_login ]] && touch /etc/TerminusBot/usuario_segundo_login
  [[ ! -f /etc/TerminusBot/link_playstore ]] && touch /etc/TerminusBot/link_playstore
  [[ ! -f /etc/TerminusBot/link_mediafire ]] && touch /etc/TerminusBot/link_mediafire
  [[ ! -f /etc/TerminusBot/link_suporte ]] && touch /etc/TerminusBot/link_suporte


  


  
  [[ -f /etc/TerminusBot/conta_teste.sh ]] && chmod +x /etc/TerminusBot/conta_teste.sh


  chmod +x /etc/TerminusBot/criarusuario.sh
  chmod +x /etc/TerminusBot/criarteste.sh
  [[ -f /etc/TerminusBot/verificar-pagamento.sh ]] && chmod +x /etc/TerminusBot/verificar-pagamento.sh
  chmod +x /etc/TerminusBot/TBot.sh
  [[ -f /etc/TerminusBot/link_download.sh ]] && chmod +x /etc/TerminusBot/link_download.sh
  [[ -f /etc/TerminusBot/link_download.sh ]] &&  source /etc/TerminusBot/link_download.sh
  
 if [[ -f .pedidos.db ]]
 then
  clear
  read -p "${Yellow}[-] Já existe um banco de dados. Deseja apagar?${Norm} ${White}[Y/n]${Norm}" escolha
  escolha=$(echo $escolha | egrep 'Y|y')

  if [[ -n $( echo $escolha | egrep 'Y|y')  ]]
  then 
    rm .pedidos.db
    echo "${Magenta}[-] Removendo banco ${Norm}"
    sleep 2
    touch .pedidos.db
    baixar_dependencias
    #alocar_bot
    clear
    echo "${Yellow}[-] Para iniciar o menu na proxima vez digite: \"terminus\"${Norm}"
   
  else
    baixar_dependencias
    clear
    echo "${Yellow}[-] Para iniciar o menu na proxima vez digite: \"terminus\"${Norm}"
  fi
    
 fi
  touch /etc/TerminusBot/pedidos.db
  baixar_dependencias
  alocar_bot
  clear
  echo "Para iniciar o menu na proxima vez digite: \"terminus\""
   

}

#==========================================================================================|
alocar_bot(){
 
 mv TerminusBot.sh terminus
 chmod +x terminus
 cp terminus /bin
 mv terminus TerminusBot.sh
 chmod +x TerminusBot.sh

  
}

token_bot(){
  echo $1 > /etc/TerminusBot/info-bot

}


#=================================#

#menu_principal

if [[  $0 == "./TerminusBot.sh" ]]
then
 criar_arquivos
 sleep 3
else
 menu_principal
fi

