#!/bin/bash

MAX_JOBS=5
count=0

for dir in */; do
    (
        cd "$dir" || exit

        if [ -d ".git" ]; then
            echo "[+] $dir"

            git add . &&
            git commit -m "auto push $(date '+%F %T')" &>/dev/null

            git push origin main
        fi
    ) &

    ((count++))

    # Limita concorrência
    if (( count % MAX_JOBS == 0 )); then
        wait
    fi
done

wait
echo "[✔] Finalizado"