#!/bin/bash
# Script de Hardening Versão 2.3 - cyberbessa
# LinkedIn: linkedin.com/in/cyberbessa
# YouTube: youtube.com/@cyberbessa
# Grupo no Telegram: https://t.me/+91kR4N_li005M2Nh
# Forked from: Israel Cavalcante @icfranca

#Funções

funcao_updatepkg(){
    # 1. Atualizar pacotes do sistema
    echo "Atualizando pacotes do sistema..."
    sleep 1
    sudo apt update && sudo apt upgrade -y
    clear
    funcao_menu
}

funcao_createuser (){
    # 2. Adicionar um novo usuário e incluir no grupo sudo
    echo "Criando um novo usuário $usuario..."
    sleep 1
    read -p "Digite o nome do usuário: " usuario
    sudo adduser $usuario --gecos "Primeiro Último,NúmeroSala,TelefoneTrabalho,TelefoneCasa" --disabled-password
    echo "Adicionando $usuario ao grupo sudo..."
    sleep 1
    sudo usermod -aG sudo $usuario
    clear
    funcao_menu
}

funcao_disallowrootssh(){
    # 3. Desativar login root via SSH
    echo "Desativando login root via SSH..."
    sleep 1
    sudo sed -i 's/PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
    clear
    funcao_menu
}

funcao_disablepassssh(){
    # 4. Desativar autenticação por senha para SSH (permitir apenas chaves SSH)
    echo "Desativando autenticação por senha para SSH..."
    sleep 1
    sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    clear
    funcao_menu
}

funcao_hardeningssh(){
    # 5. Hardening adicional do SSH
    echo "Aplicando hardening adicional no SSH..."
    sleep 1

    # Desativar encaminhamento X11
    sudo sed -i 's/#X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config

    # Desativar senhas vazias
    sudo sed -i 's/#PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config

    # Desativar encaminhamento TCP
    echo "AllowTcpForwarding no" | sudo tee -a /etc/ssh/sshd_config

    # Limitar tentativas de login SSH para mitigar ataques de força bruta
    echo "MaxAuthTries 3" | sudo tee -a /etc/ssh/sshd_config

    # Desativar encaminhamento X11
    sudo sed -i 's/#X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config

    # Desativar senhas vazias
    sudo sed -i 's/#PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config

    # Desativar encaminhamento TCP
    echo "AllowTcpForwarding no" | sudo tee -a /etc/ssh/sshd_config

    # Limitar tentativas de login SSH para mitigar ataques de força bruta
    echo "MaxAuthTries 3" | sudo tee -a /etc/ssh/sshd_config
    clear
    funcao_menu
}

funcao_sshport(){
    # 6. Alterar a porta SSH (opcional, recomendado usar uma porta não padrão)
    if ! command -v sshd &> /dev/null
    then
        echo "O serviço SSH não está instalado. Instalando o OpenSSH Server..."
        sudo apt install openssh-server -y
        SSH_PORT=2222
        echo "Alterando a porta SSH para $SSH_PORT..."
        sleep 1
        sudo sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
           clear
        funcao_menu

    else
        echo "O serviço SSH já está instalado."
       SSH_PORT=2222
         echo "Alterando a porta SSH para $SSH_PORT..."
        sleep 1
        sudo sed -i "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
        clear
        funcao_menu
    fi
}

funcao_ufw(){
    # 7. Ativar o UFW (Uncomplicated Firewall)
    echo "Ativando o UFW e configurando regras básicas de firewall..."
    sleep 1
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    # Permitir SSH na nova porta
    sudo ufw allow $SSH_PORT/tcp
    # Permitir HTTP, HTTPS e SSH
    sudo ufw allow 80/tcp
    sudo ufw allow 443/tcp
    sudo ufw allow 2222/tcp
    # Ativar o firewall
    sudo ufw enable

    clear
    funcao_menu
}

funcao_fail2ban(){
    # 8. Instalar e configurar Fail2Ban para proteção SSH
    echo "Esta instalação rodará um script e finalizará a execução do script atual."
    sleep 1
    ./fail2ban.sh
    clear
    funcao_menu
}

funcao_securepasswd(){
    # 9. Definir permissões em /etc/passwd e /etc/shadow
    echo "Definindo permissões seguras em /etc/passwd e /etc/shadow..."
    sudo chmod 644 /etc/passwd
    sudo chmod 600 /etc/shadow
    clear
    funcao_menu
}

funcao_autoupdate(){  
    # 10. Configurar atualizações automáticas de segurança
    echo "Ativando atualizações automáticas de segurança..."
    sudo apt install unattended-upgrades -y
    sudo dpkg-reconfigure -plow unattended-upgrades
    clear
    funcao_menu
}

funcao_strongpasswd(){
    # 11. Configurar políticas de senha fortes
    echo "Configurando políticas de senha fortes..."
    sudo apt install libpam-pwquality -y
    echo "password requisite pam_pwquality.so retry=3 minlen=12 difok=3" | sudo tee -a /etc/pam.d/common-password
    clear
    funcao_menu
}

fucao_restardsshfw(){
    # 12. Recarregar SSH e UFW
    echo "Recarregando serviços SSH e UFW..."
    sudo systemctl reload sshd
    sudo ufw reload
    echo "Serviços recarregados com sucesso!"
    sleep 1
    clear
    funcao_menu
}

funcao_menu (){
# Menu

echo "Escolha uma opção:"
echo "1. Atualizar pacotes do sistema"
echo "2. Adicionar um novo usuário e incluir no grupo sudo"
echo "3. Desativar login root via SSH"
echo "4. Desativar autenticação por senha para SSH (permitir apenas chaves SSH)"
echo "5. Hardening adicional do SSH"
echo "6. Alterar a porta SSH (opcional, recomendado usar uma porta não padrão)"
echo "7. Ativar o UFW (Uncomplicated Firewall)"
echo "8. Instalar e configurar Fail2Ban para proteção SSH"
echo "9. Definir permissões em /etc/passwd e /etc/shadow"
echo "10. Configurar atualizações automáticas de segurança"
echo "11. Configurar políticas de senha fortes"
echo "0. Sair"

read -p "Digite o número da opção desejada: " opcao

case $opcao in
    1)
        funcao_updatepkg
        ;;
    2)
        funcao_createuser
        ;;
    3)
        funcao_disallowrootssh
        ;;
    4)
        funcao_disablepassssh
        ;;
    5)
        funcao_hardeningssh
        ;;
    6)
        funcao_sshport
        ;;
    7)
        funcao_ufw
        ;;
    8)
        funcao_fail2ban
        ;;
    9)
        funcao_securepasswd
        ;;
    10)
        funcao_autoupdate
        ;;
    11)
        funcao_strongpasswd
        ;;
    0)
        echo "Saindo..."
        ;;
    *)
        echo "Opção inválida. Saindo..."
        ;;
esac
}