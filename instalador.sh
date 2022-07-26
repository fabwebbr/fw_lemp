#!/bin/bash
#
# Objetivo do script: instalar Nginx, PHP 7.4, MySQL.
# Feito para debian/ubuntu
#
# Desenvolvido por Felipe Barreto
###############################################################################################

# Qual timezone usar?
timezone="America/Sao_Paulo"


##############################################################################################
##############################################################################################
##############################################################################################
# Debug? (# = não)
# set -x
# Gerador de numero aleatório
int=$(shuf -i 10-100 -n 1)
# Gerador de senha aleatória para o BD
password_db=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c34)

echo "Iniciando o processo...."
timedatectl set-timezone $timezone > /dev/null 2>&1
apt-get --yes --quiet update > /dev/null 2>&1
if [ ? -eq 0 ]; then
 echo "As atualizações foram aplicadas"
fi

# Instalando Apache e habilitando módulos
if [ -d "/etc/apache2" ]; then
 echo "NGINX: Já existe uma instalação do apache. Verifique isso para evitar conflitos."; 
 exit;
else
 echo "NGINX: Iniciando instalação"
 apt-get --yes install nginx > /dev/null 2>&1
 ufw allow "Nginx Full" > /dev/null 2>&1
 
 echo "NGINX + SSL: Instalando certbot para apache..."
 apt-get --yes install python3-certbot-nginx > /dev/null 2>&1
fi

 echo "PHP: Iniciando instalação do php 7.4..."
 apt install php7.4 -y --quiet > /dev/null 2>&1
 apt --yes install php7.4-cli php7.4-fpm php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath php7.4-imagick php7.4-intl php7.4-soap > /dev/null 2>&1
 echo "PHP: php7.4-fpm foi instalado e está pronto para uso com Nginx"

 echo "MySQL: Iniciando a instalação do MySQL Server"
 apt-get --yes --quiet install mysql-server > /dev/null 2>&1
 mysql -e "create user admin_${int}@localhost IDENTIFIED WITH mysql_native_password BY '$password_db'" > /dev/null 2>&1
 mysql -e "GRANT ALL PRIVILEGES ON *.* TO admin_${int}@localhost" > /dev/null 2>&1
 mysql -e "FLUSH PRIVILEGES" > /dev/null 2>&1
cat > /root/.my.cnf << EOF
[client]
user=admin_${int}
password=$password_db
EOF
 echo "MySQL: Instalação do MySQL concluída com sucesso"