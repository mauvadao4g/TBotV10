#!/bin/bash

BASE_DIR="$(pwd)"

echo "[*] Iniciando atualização..."
echo

for dir in */; do
    echo "======================================="
    echo "[+] Pasta: $dir"

    cd "$dir" || continue

    if [ -d ".git" ]; then
        echo "[*] Repo Git encontrado"

        REPO_PATH="$(pwd)"

        # Corrige erro de "dubious ownership"
        git config --global --add safe.directory "$REPO_PATH" 2>/dev/null

        # Detecta branch
        BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

        if [ -z "$BRANCH" ]; then
            echo "[!] Não conseguiu detectar branch, pulando..."
        else
            echo "[*] Branch: $BRANCH"

            # script que atualiza repositorio
            bash subGit.sh

            if [ $? -eq 0 ]; then
                echo "[OK] Atualizado"
            else
                echo "[ERRO] Falha no pull"
            fi
        fi
    else
        echo "[!] Não é repo Git"
    fi

    echo
    cd "$BASE_DIR"
done

echo "======================================="
echo "[*] Finalizado"
