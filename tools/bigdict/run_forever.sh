#!/bin/bash
# Keeps translating until every batch exists; waits 30 min when the free quota runs out.
cd /c/Users/UTENTE/dictdata
while true; do
  done_n=$(ls out/tr | wc -l)
  if [ "$done_n" -ge 2500 ]; then echo "ALL DONE $(date)" >> out/forever.log; break; fi
  if ! powershell -NoProfile -Command "if ((Get-CimInstance Win32_Process -Filter \"Name='python.exe'\" | Where-Object { \$_.CommandLine -like '*translate.py*' }).Count -gt 0) { exit 0 } else { exit 1 }"; then
    echo "$(date) restart at $done_n" >> out/forever.log
    NO_STRONG=1 python -I scripts/translate.py --limit 100000 --workers 24 >> out/translate.log 2>&1
  fi
  if ! powershell -NoProfile -Command "if ((Get-CimInstance Win32_Process -Filter \"Name='python.exe'\" | Where-Object { \$_.CommandLine -like '*gen_phrases.py*' }).Count -gt 0) { exit 0 } else { exit 1 }"; then
    NO_STRONG=1 python -I scripts/gen_phrases.py --workers 6 >> out/phrases.log 2>&1 &
  fi
  sleep 1800
done
