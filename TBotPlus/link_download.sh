#!/bin/bash

Bold=$(tput bold)
Norm=$(tput sgr0)
Yellow=$(tput setaf 3)
Red=$(tput setaf 1)
Green=$(tput setaf 2)

menu_app_download(){
  [[ -n $(cat /etc/TerminusBot/link_playstore) ]] && link_playstore="ok" || link_playstore=""
  [[ -n $(cat /etc/TerminusBot/link_mediafire) ]] && link_mediafire="ok" || link_mediafire=""

  tput cup 3 1
  tput setab 7 
  tput setaf 0
  echo "               Adicionar link para download                 "
  tput sgr0

  tput cup 6 1
  echo "${Bold}${Red}[${Norm}1${Red}]${Norm} ${Yellow}${Bold}Link Play Store${Norm}${Norm} [${Green}${link_playstore}${Norm}]"       
  tput sgr0
  tput cup 7 1
  echo "${Bold}${Red}[${Norm}2${Red}]${Norm} ${Yellow}${Bold}Link Media Fire${Norm}${Norm} [${Green}${link_mediafire}${Norm}]"       
  tput sgr0
  tput cup 8 1
  echo "${Bold}${Red}[${Norm}3${Red}]${Norm} ${Yellow}${Bold}Voltar${Norm}${Norm}"       
  tput sgr0
  link_app
}


link_app(){
  while :
 do
    echo -e "\n"
    read -p "Escolha:> " escolha
    if [[ $escolha == "1" ]]
    then
      while :
      do
        echo "${Yellow}${Bold}[-] Digite o link do seu app na Play Store${Norm}${Norm}"
        read -p ":> " link
        [[ -n $link ]] && {
          echo $link > /etc/TerminusBot/link_playstore
          clear
          echo "${Green}${Bold}[-] Link da Play Store foi salvo com sucesso!${Norm}${Norm}"
          sleep 2
          menu_app_download
          break
         } || {
           echo "${Red}${Bold}[!] Link vazio! ${Norm}${Norm}"
            sleep 2
            break
         }
      done
    fi
    
    if [[ $escolha == "2" ]]
    then
      while :
      do
        echo "${Yellow}${Bold}[-] Digite o link do seu app fora da playstore${Norm}${Norm}"
        echo "${Magenta}${Bold}[-] Pode ser MediaFire / Mega ${Norm}${Norm}"
        read -p ":> " link
        [[ -n $link ]] && {
          echo $link > /etc/TerminusBot/link_mediafire
          clear
          echo "${Green}${Bold}[-] Link de download foi salvo com sucesso!${Norm}${Norm}"
          sleep 2
          clear
          menu_app_download
          break
         } || {
           echo "${Red}${Bold}[!] Link vazio! ${Norm}${Norm}"
           sleep 2
           exit 1
         }
      done
    fi
    if [[ $escolha == "3" ]]
    then
      terminus
      break
      exit 1
    fi
 done
}