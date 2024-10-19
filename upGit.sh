 #!/bin/bash
# MAUVADAO
# VER 1.0.7
# FAÇA UPDATE DOS SEUS ARQUIVOS PRO GIT HUB DE FORMA MAIS RAPIDA E FACIL
# ATUALIZA O NUMERO DA VERSAO DO FILE AUTOMATICAMENTE
#
clear

filtroMsg(){
sed -r 's/\\e\[m//g ; s/\\e.*[0-9]{2}m//g ; s/\\033.*[0-9]m//g'
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
#    echo "Token já existente. Gerando atualização..."
#   sleep 1
    source "$token_file"
  fi
##### || ######


# Primeiro commit
_gitconfig(){
git config --global --add safe.directory /storage/emulated/0/MAUVADAO/MAUVADAO_GITHHUB/Mauvadao-tools
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



# Verifica se o arquivo foi encontrado
VER=$(ls *.txt | grep -oP "\bver[0-9]{1,}\.txt\b")
if [[ -z "$VER" ]]; then
    echo "Erro: Nenhum arquivo de versão encontrado."

    echo "#      ATUALIZADO
DATA: 27/08/2024
VER: 25
HORAS: 20:05

" > ver0.txt

#    exit 1
fi

# Criando as variáveis para o script
file=$(ls *.txt | grep -oP "ver[0-9]{1,}.txt" | head -n 1)
version=$(echo "$file" | grep -oP "[0-9]+")
new_version=$((version + 1))
new_file="ver${new_version}.txt"
horas="$(date +%d/%m/%Y_%R)"
# mensagem="---NEW UPDATE---"
mensagem="    ---NEW UPDATE---        "
notas="${1:-$mensagem}"



# Renomeando o arquivo para o próximo número de versão
mv "$file" "$new_file"
file="$new_file"

# Atualizando as informações de DATA, VER e HORAS no arquivo
sed -i "s|^DATA:.*|DATA: $(date +%d/%m/%Y)|" "$file"
sed -i "s|^VER:.*|VER: $new_version|" "$file"
sed -i "s|^HORAS:.*|HORAS: $(date +%R)|" "$file"

# Função para gerar logs para atualização
_logs(){
echo "............................." >> "$file"
echo "            UPLOAD           " >> "$file"
echo "............................." >> "$file"
echo "          User: $(whoami)       " >> "$file"
 echo "● Update: $(date +%d/%m/%Y_%R)" >> "$file"
 echo "         VER: ${new_version}   " >> "$file"
echo "............................." >> "$file"
echo "○ $notas" >> "$file"
echo "............................." >> "$file"
echo '' >> "$file"
}

# Chamando a função de logs
_logs

echo -e "\e[1;37mAtualizando repositório do GitHub\e[m"; sleep 1
echo -e '\033[2;37'
# Comando para fazer o upload para o GitHub
git add -A && git commit -m "Update: $(date +%d/%m/%Y_%R)" && git push && {
clear
   echo -e "\e[1;32m"
   echo -e "Atualizado" | figlet; } || {
   echo -e '\e[m'
  clear
   echo -e "\e[1;31m"
   echo -e "\e[1;31mERROR\e[m" | figlet
   echo -e '\e[m'
   }

#   MOSTRANDO DADOS NA TELA
TELA=$(
echo -e "\033[1;36m.............................
            UPLOAD
.............................\033[m"
GITHOME="$base"
# echo "$horas"
echo -e "\t  \e[1;33m$GITHOME\e[m"
# echo "VER: $(echo "$file" | grep -oP "[0-9]+")"
# abrir o file.txt
echo -e '\033[1;34m'
 cat ver[0-9]*.txt | tail -n 7
echo -e '\033[m'
)
# -----------||-----------#
echo "$TELA"


#   ENVIANDO ESSA MENSAGEM
MSG="$(
echo  "................................
          UPLOAD
................................"
GITHOME="$base"
echo "      $GITHOME"
# abrir o file.txt
 cat ver[0-9]*.txt | tail -n 7
)"
_enviar_msg $TOKEN $CHATID "$MSG" >/dev/null 2>&1
# -----------||-----------#


#  Veridicar se foi envisdo corretamente
  status_msg=$?
  if [ $status_msg -eq 0 ]; then
    echo -e "\033[1;32mSend-Telegram: Enviada\033[m"
  else
    echo -e "\033[1;31mSend-Telegram: Algo deu errado\033[m"
    exit 1
  fi

