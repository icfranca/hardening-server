#!/bin/bash

# Instalar e configurar Fail2Ban para proteção SSH
echo "Instalando e configurando Fail2Ban..."
sleep 1
sudo apt install fail2ban -y

# Configurar Fail2Ban para proteção SSH
SSH_PORT=22  # Defina a porta SSH aqui, se for diferente de 22
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOL
[sshd]
enabled = true
port = $SSH_PORT
logpath = %(sshd_log)s
maxretry = 3
bantime = 3600
EOL

# Reiniciar Fail2Ban para aplicar a configuração
sudo systemctl restart fail2ban

echo "Fail2Ban instalado e configurado com sucesso."
sleep 1