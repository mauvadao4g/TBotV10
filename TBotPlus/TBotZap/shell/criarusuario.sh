      # # Comando para pegar o IP da máquina
  IP=$(curl -s http://whatismyip.akamai.com/)
      #USERNAME Uso no máximo 10 caracteres - Maior que dois digitos - Não use espaço, acentos ou caracteres especiais - Não pode ficar vazio
      username=$(echo $RANDOM | md5sum | head -c 9; echo;)
      #PASSWORD Número no minimo 4 digitos - Não pode ficar vazio. 
      password=$(echo $RANDOM | md5sum | head -c 5; echo;)
      #SSHLIMITER Deve ser maior que zero - Apenas número - Não pode ficar vazio
      sshlimiter=$(cat /etc/TerminusBot/acessos)
      # DIAS Deve ser maior que zero - Deve ser apenas número - Não pode ficar vazio
      dias=$(cat /etc/TerminusBot/tempo-conta)

      final=$(date "+%Y-%m-%d" -d "+$dias days")
      gui=$(date "+%d/%m/%Y" -d "+$dias days")
      pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
      useradd -e $final -M -s /bin/false -p $pass $username >/dev/null 2>&1 &
      echo "$password" >/etc/SSHPlus/senha/$username
      echo "$username $sshlimiter" >>/root/usuarios.db

      echo '{
        "IP": "'${IP}'",
        "Usuario": "'${username}'",
        "Senha": "'${password}'",
        "expira": "'${dias}' dias",
        "limite": "'${sshlimiter}' usuario"
      }'

   