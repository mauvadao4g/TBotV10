#!/bin/bash
# fix_ssh_perm.sh

set -e

SSH_DIR="$HOME/.ssh"
CONFIG="$SSH_DIR/config"
PRIV_KEY="$SSH_DIR/github"
PUB_KEY="$SSH_DIR/github.pub"

echo "[+] Ajustando permissões..."

# Cria pasta .ssh se não existir
if [[ ! -d "$SSH_DIR" ]]; then
    echo "[!] ~/.ssh não existe, criando..."
    mkdir -p "$SSH_DIR"
fi

chmod 700 "$SSH_DIR"

# Ajusta arquivos se existirem
[[ -f "$CONFIG"   ]] && chmod 600 "$CONFIG"
[[ -f "$PRIV_KEY" ]] && chmod 600 "$PRIV_KEY"
[[ -f "$PUB_KEY"  ]] && chmod 644 "$PUB_KEY"

echo "[+] Verificando permissões..."

erro=0

perm_ssh=$(stat -c "%a" "$SSH_DIR")
[[ "$perm_ssh" != "700" ]] && { echo "[ERRO] ~/.ssh != 700 ($perm_ssh)"; erro=1; }

if [[ -f "$CONFIG" ]]; then
    perm_config=$(stat -c "%a" "$CONFIG")
    [[ "$perm_config" != "600" ]] && { echo "[ERRO] config != 600 ($perm_config)"; erro=1; }
fi

if [[ -f "$PRIV_KEY" ]]; then
    perm_priv=$(stat -c "%a" "$PRIV_KEY")
    [[ "$perm_priv" != "600" ]] && { echo "[ERRO] id_rsa != 600 ($perm_priv)"; erro=1; }
fi

if [[ -f "$PUB_KEY" ]]; then
    perm_pub=$(stat -c "%a" "$PUB_KEY")
    [[ "$perm_pub" != "644" ]] && { echo "[ERRO] id_rsa.pub != 644 ($perm_pub)"; erro=1; }
fi

if [[ $erro -eq 0 ]]; then
    echo "[OK] Permissões corrigidas com sucesso!"
else
    echo "[FALHA] Ainda há permissões incorretas."
    exit 1
fi

echo "[+] Testando conexão com GitHub..."
if ssh -T git@github.com 2>&1 | grep -qi "successfully authenticated"; then
    echo "[OK] SSH funcionando com GitHub!"
else
    echo "[ERRO] SSH ainda não autenticou no GitHub"
    exit 1
fi
