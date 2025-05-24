# 💽 Disk Space Alert – DevOps Automation Project

Questo progetto Bash monitora lo spazio disco del filesystem root (`/`) e invia una notifica via email se l’utilizzo supera una soglia configurabile (default 80%). Il controllo avviene automaticamente ogni giorno tramite `cron`.

---

## 📁 Struttura del progetto

```
devops-automation-disk/
├── check_disk.sh         # Script principale
├── disk_alert.log        # Log automatico giornaliero
├── .gitignore            # Esclude file di log dal repo
├── README.md             # Questo file
```

---

## 🔧 Script – `check_disk.sh`

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
```

---

## 🛠️ Configurazione Email (msmtp + Gmail)

1. Installa `msmtp`:
```bash
sudo apt install msmtp msmtp-mta -y
```

2. Crea `~/.msmtprc`:
```ini
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
```

3. Proteggi il file:
```bash
chmod 600 ~/.msmtprc
```

4. Testa:
```bash
echo "Test notifica" | msmtp TUA_EMAIL@gmail.com
```

---

## 🕒 Automatizzazione con cron

Per eseguire il check ogni giorno alle 08:00:

```cron
0 8 * * * /home/<user>/devops-automation-disk/check_disk.sh
```

Aggiungilo al tuo crontab con:
```bash
crontab -e
```

---

## 📄 Output esempio

Nel file `disk_alert.log`:
```
[2025-05-24 08:00:00] OK - Disco al 45%
[2025-05-25 08:00:00] ⚠️ Disco sopra 80%: attuale 91%
```

Email:
```
Attenzione: lo spazio su disco ha superato la soglia.
Utilizzo attuale: 91%
```

---

## 👨‍💻 Tecnologie usate

- Bash
- Cron
- msmtp + Gmail App Password
- comandi: `df`, `awk`, `sed`

---

## 👤 Autore

[Emanuele Alessio](https://github.com/emanuelealessio)
