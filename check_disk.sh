#!/bin/bash

# === CONFIG ===
THRESHOLD=80
LOG_FILE="$HOME/devops-automation-disk/disk_alert.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# === ESTRAI UTILIZZO DISCO ===
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

# === VERIFICA ===
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "[$DATE] ⚠️ Disco sopra ${THRESHOLD}%: attuale ${USAGE}%" >> "$LOG_FILE"
    echo -e "Attenzione: lo spazio su disco ha superato la soglia.\nUtilizzo attuale: ${USAGE}%" | msmtp emanuelealessio80@gmail.com
else
    echo "[$DATE] OK - Disco al ${USAGE}%" >> "$LOG_FILE"
fi
