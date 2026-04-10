#!/bin/bash
# mauvadao
# ver: 1.0.0
# gitPushAll.sh -> push em todos repos locais

BASE_DIR="$(pwd)"

# cores
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

log(){ echo -e "${BLUE}[*]${NC} $1"; }
ok(){ echo -e "${GREEN}[+]${NC} $1"; }
warn(){ echo -e "${YELLOW}[!]${NC} $1"; }
err(){ echo -e "${RED}[-]${NC} $1"; }

# verifica git
command -v git >/dev/null || { err "Git não instalado"; exit 1; }

# testa conexão github via ssh
_test_ssh(){
    ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"
}

log "Verificando SSH com GitHub..."
if _test_ssh; then
    ok "SSH OK"
else
    warn "SSH pode não estar configurado corretamente"
fi

echo

for dir in */; do
    echo -e "${YELLOW}=======================================${NC}"
    echo -e "${BLUE}[*] Pasta: ${dir}${NC}"

    cd "$BASE_DIR/$dir" || continue

    # verifica se é repo
    if [ -d ".git" ]; then
        log "Repo Git encontrado"

        # evita erro safe.directory
        git config --global --add safe.directory "$(pwd)" 2>/dev/null

        # pega branch atual
        BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

        if [ -z "$BRANCH" ]; then
            err "Não foi possível identificar branch"
            cd "$BASE_DIR"
            continue
        fi

        log "Branch: $BRANCH"

        # verifica mudanças
        if git status --porcelain | grep . >/dev/null; then
            warn "Alterações detectadas"

            git add . || { err "Erro no git add"; cd "$BASE_DIR"; continue; }

            git commit -m "auto commit $(date '+%Y-%m-%d %H:%M:%S')" \
            || warn "Nada para commitar"

            git push origin "$BRANCH" \
            && ok "Push realizado" \
            || err "Falha no push"
        else
            log "Nada para enviar"
        fi

    else
        warn "Não é repositório Git"
    fi

    cd "$BASE_DIR"
    echo
done

ok "Finalizado"
