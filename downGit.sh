#!/bin/bash
#  MAUVADAO
#  VER 1.0.2
#  DATA: 13/10/2024
#  BAIXA OS ARQUIVOS DO GIT HUB
clear

# Função para exibir mensagens coloridas
print_msg() {
    case $1 in
        "error") echo -e "\e[1;31m$2\e[m" ;;   # Vermelho
        "success") echo -e "\e[1;32m$2\e[m" ;; # Verde
        "warning") echo -e "\e[1;33m$2\e[m" ;; # Amarelo
        "info") echo -e "\e[1;36m$2\e[m" ;;    # Ciano
        *) echo "$2" ;;                        # Sem cor
    esac

#        MODO DE USAR A FUNCAO
# print_msg "error" "Mensagem de Erro"
# print_msg "success" 'Mensagem de Sucesso'
# print_msg 'warning' 'Mensagem de warning'
# print_msg 'info' 'Mensagem de info'
}

# Função para enviar uma mensagem de texto
_enviar_msg() {

local token="$1"
local chat_id="$2"
local text="$3"

   response=$( url="https://api.telegram.org/bot$token/sendMessage"
    curl -s -X POST "$url" \
        -d "chat_id=$chat_id" \
        -d "text=$text" \
        -d "parse_mode=HTML"
)

  echo "$response" | grep -q '"ok":true'
  return $?

}


# Pegando o nome da Pasta atual
base="$(basename "$(pwd)")"
#### GERANDO TOKENS ####
# Pegando Token
  token_file="$HOME/tokens.sh" # Expande corretamente o caminho do arquivo de token

  # Verificando se o arquivo de token existe
  if [ ! -f "$token_file" ]; then
    echo "Token não encontrado. Criando novo token..."
    read -p "Token Telegram: " TOKEN
    read -p "ChatId: " chatID

    # Salvando o token e chatID no arquivo
    echo "TOKEN=$TOKEN" # | tee -a "$token_file"
    echo "CHATID=$chatID" # | tee -a "$token_file"

cat <<EOF > $token_file
#!/bin/bash
# Tokens do telegram
TOKEN=$TOKEN
CHATID=$chatID
EOF
    # Carregando o arquivo de token
    source "$token_file"
  else
    source "$token_file"
  fi
##### || ######
#   bash      #
#  script     #
###############




#     RODANDO A PARTE PRINCIPAL DO DOWNLOAD
print_msg 'warning' 'Baixando os arquivos'
git pull

if [[ $? = 0 ]]
then
sleep 1
clear
echo "MauDaVpn" | figlet
print_msg 'info' '######################'
print_msg 'info' " Baixado com Sucesso "
print_msg 'info' '######################'
cat ver[0-9]*.txt | tail -n 7

else
clear
print_msg 'error' "Algo deu errado"
fi
#-------------------||----------------------------

# ENVIANDO MENSAGEM AO TELEGRAM
MSG="$(
##################################################
echo "             DOWNLOAD                      "
##################################################
GITHOME="$base"
echo "User: $(whoami)"
echo "$horas"
echo -e "\t  $GITHOME"
# echo "VER: $(echo "$file" | grep -oP "[0-9]+")"
# abrir o file.txt
 cat ver[0-9]*.txt | tail -n 7
 #################################################
)"
# -----------||-----------#

# chamando a função pra enviar a mensagem
_enviar_msg $TOKEN $CHATID "$MSG" >/dev/null 2>&1

#  Veridicar se foi envisdo corretamente
  status_msg=$?
  if [ $status_msg -eq 0 ]; then
    echo "Send: Enviada"
  else
    echo "Send: Algo deu errado"
    exit 1
  fi
#----------------------||--------------------------





