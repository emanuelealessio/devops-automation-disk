# 💽 Disk Space Alert – DevOps Automation Project #3

Un semplice sistema di **monitoraggio automatico dello spazio disco** con **notifica via email gratuita** usando `Bash`, `cron` e `msmtp`.

Progetto utile in ambienti DevOps/SysAdmin per garantire che i sistemi non vadano in blocco per mancanza di spazio.

---

## 🧠 Obiettivo

- Monitorare lo spazio del filesystem root `/`
- Loggare lo stato ogni 24 ore
- Inviare una notifica email se lo spazio supera una soglia critica (default: **80%**)

---

## 🗂️ Struttura del progetto

devops-automation-disk/
├── check_disk.sh # Script principale di monitoraggio
├── disk_alert.log # Log automatico giornaliero
├── README.md # Questo file


---

## 🔧 Script principale – `check_disk.sh`

```bash
#!/bin/bash

THRESHOLD=80
LOG_FILE="$HOME/devops-automation-disk/disk_alert.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "[$DATE] ⚠️ Disco sopra ${THRESHOLD}%: attuale ${USAGE}%" >> "$LOG_FILE"
    echo -e "Attenzione: lo spazio su disco ha superato la soglia.\nUtilizzo attuale: ${USAGE}%" | msmtp TUA_EMAIL@gmail.com
else
    echo "[$DATE] OK - Disco al ${USAGE}%" >> "$LOG_FILE"
fi



📬 Configurazione Email (msmtp + Gmail)

# Installa msmtp

sudo apt update
sudo apt install msmtp msmtp-mta -y


## Crea il file ~/.msmtprc

defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

account gmail
host smtp.gmail.com
port 587
from TUA_EMAIL@gmail.com
user TUA_EMAIL@gmail.com
password "LA_TUA_APP_PASSWORD"

account default : gmail


### Proteggi il file

chmod 600 ~/.msmtprc



🕒 Automazione con cron
Per schedulare lo script una volta al giorno (es. alle 8:00):

cron

0 8 * * * /home/<user>/devops-automation-disk/check_disk.sh

Modifica il tuo crontab

✅ Output previsto

In disk_alert.log:

[2025-05-24 08:00:00] OK - Disco al 45%
[2025-05-25 08:00:00] ⚠️ Disco sopra 80%: attuale 91%

Notifica email:

Oggetto: (nessuno)
Contenuto:
Attenzione: lo spazio su disco ha superato la soglia.
Utilizzo attuale: 91%
 
