#!/bin/bash

find . -maxdepth 1 -type d | tail -n +2 | xargs -I{} -P 5 bash -c '
cd "{}" || exit

if [ -d ".git" ]; then
    echo "[+] {}"

    git add . &&
    git commit -m "auto push $(date "+%F %T")" &>/dev/null

    git push origin main
fi
'