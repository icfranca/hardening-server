### Script para Hardening de servidores com Ubuntu



- [Introdução](#introdução)
- [Instalação](#instalação)
- [Funcionalidades](#funcionalidades)


## Introdução

Este script faz um processo de hardening em servidores rodando distribuição Ubuntu.

## Instalação

Faça o clone ou download dos arquivos para seu computador

```sh
git clone https://github.com/Cyberbessa/script-live.git
```

Dentro do diretório onde estãos arquivos baixados dê permissão de execução aos scripts.

```sh
chmod +x HardeningLive.sh
```

```sh
chmod +x fail2ban.sh
```
## Executando
```sh
./HardeningLive.sh
```

## Funcionalidades

Os comandos executados no script irá fazer as alterações de acordo com a escolha no menu.


-  1 - Atualizar pacotes do sistema
-  2 - Adicionar um novo usuário e incluir no grupo sudo
-  3 - Desativar login root via SSH
-  4 - Desativar autenticação por senha para SSH (permitir apenas chaves SSH)
-  5 - Hardening adicional do SSH
-  6 - Alterar a porta SSH (opcional, recomendado usar uma porta não padrão)
-  7 - Ativar o UFW (Uncomplicated Firewall)
-  8 - Instalar e configurar Fail2Ban para proteção SSH
-  9 - Definir permissões em /etc/passwd e /etc/shadow
- 10 - Configurar atualizações automáticas de segurança
- 11 - Configurar políticas de senha fortes
