#!/bin/bash

# Mise a jour
apt-get update -y
apt-get upgrade -y

# Installation des dépandances
apt-get install apache2 php7.3 libapache2-mod-php7.3 mysql-server php7.3-mysql php7.3-gd php7.3-mbstring php7.3-xml

# Installation de TeamPass
wget https://github.com/teampassnet/teampass/releases/download/2.1.27.29/teampass-2.1.27.29.zip

# Décompression
unzip teampass-2.1.27.29.zip

# Déplacer fichier décompréser dans Apach
cp -r teampass /var/www/html/teampass

# Modiffier les autorisation de TeamPass
chown -R www-data:www-data /var/www/html/teampass
chmod 775 /var/www/html/teampass/includes
chmod 775 /var/www/html/teampass/install

# Logine a la DB
mysql -u root -p

# Creation de Base de donnée
CREATE DATABASE teampass;
GRANT ALL PRIVILEGES ON teampass.* TO 'teampass'@'localhost' IDENTIFIED BY 'PASSWORD';
FLUSH PRIVILEGES;
EXIT;

# Acceder a l'interfase Web de TeamPass
echo -e  "\003[31m     http://[hostname]/teampass/install/install.php"

# Supretion du dossier d'installation pour securité
rm -r /var/www/html/teampass/install






