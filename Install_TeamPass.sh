#!/bin/bash
# Crée par Kuroakashiro
# Pour Ubuntu ou Debian ! 
# Tuto : https://www.howtoforge.com/how-to-setup-teampass-password-manager-on-debian-11/
# Mise a jour
# Debian sudo user -> su - USERNAM
# Executer le script en Root
apt  update -y
apt  upgrade -y
apt install net-tools -y
# Installation des dépandances
#erreur
# apt  install apache2 php7.3 libapache2-mod-php7.3 mysql-server php7.3-mysql php7.3-gd php7.3-mbstring php7.3-xml
apt install apache2 apache2-utils mariadb-server mariadb-client php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-bcmath php7.4-curl php7.4-fpm php7.4-gd php7.4-xml php7.4-mbstring -y
apt install php7.4-gmp -y
# Change setings
# max_execution_time = 60
# date.timezone = Europ/Zurich
# Potentielement il faudrais retirer le ';' avent openssl
sed -i 's/ax_execution_time = 30/ax_execution_time = 60/g' /etc/php/7.4/apache2/php.ini
sed -i 's/;date.timezon =/date.timezon = Europe\/Zurich/g' /etc/php/7.4/apache2/php.ini
sed -i 's/;extension=gmp/extension=gmp/g' /etc/php/7.4/apache2/php.ini

nano /etc/php/7.4/apache2/php.ini

# Restart Apache2
systemctl restart apache2

# Add MDP on MariaDB
mysql_secure_installation



# Login SQL
echo ""
echo "Copier et clik droit !"
echo ""
echo -e "\033[32mcreate database teampass;"
echo -e "\033[32mgrant all privileges on teampass.* to teampass@localhost identified by "password";\033[00m"
echo -e "\033[32mflush privileges;"
echo -e "\033[32mexit;\033[00m"
echo ""
echo ""
mysql -u root -p


# Install git
apt install git -y

# Install Teampass
cd /var/www/html/
git clone https://github.com/nilsteampassnet/TeamPass.git

# Change permissions
# Changement du proprietaire du fichier et 
# autorisation complaite sur le fichier sauf 
# pour les autre utilisateur qui ne peuvent pas ecrire
chown -R www-data:www-data TeamPass
chmod -R 775 /var/www/html/TeamPass

# Create an Apache Virtual Host for Teampass
# Potentelement pose problaime pour le HTTPS car la config est fait sur le port 80
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/teampass.conf
echo "     ServerAdmin admin@module300.local" >> /etc/apache2/sites-available/teampass.conf
echo "     DocumentRoot /var/www/html/TeamPass  " >> /etc/apache2/sites-available/teampass.conf
echo "     ServerName teampass.module300.local" >> /etc/apache2/sites-available/teampass.conf
echo " " >> /etc/apache2/sites-available/teampass.conf
echo "     <Directory /var/www/html/TeamPass>" >> /etc/apache2/sites-available/teampass.conf
echo "          Options FollowSymlinks" >> /etc/apache2/sites-available/teampass.conf
echo "          AllowOverride All" >> /etc/apache2/sites-available/teampass.conf
echo "          Require all granted" >> /etc/apache2/sites-available/teampass.conf
echo "     </Directory>" >> /etc/apache2/sites-available/teampass.conf
echo " " >> /etc/apache2/sites-available/teampass.conf
echo "     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log" >> /etc/apache2/sites-available/teampass.conf
echo "     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined" >> /etc/apache2/sites-available/teampass.conf
echo " " >> /etc/apache2/sites-available/teampass.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/teampass.conf

# Configue pour le port 443 'HTTPS' retirer ci Bugs !
echo "<VirtualHost *:443>" > /etc/apache2/sites-available/teampass.conf
echo "     ServerAdmin admin@module300.local" >> /etc/apache2/sites-available/teampass.conf
echo "     DocumentRoot /var/www/html/TeamPass  " >> /etc/apache2/sites-available/teampass.conf
echo "     ServerName teampass.module300.local" >> /etc/apache2/sites-available/teampass.conf
echo " " >> /etc/apache2/sites-available/teampass.conf
echo "     <Directory /var/www/html/TeamPass>" >> /etc/apache2/sites-available/teampass.conf
echo "          Options FollowSymlinks" >> /etc/apache2/sites-available/teampass.conf
echo "          AllowOverride All" >> /etc/apache2/sites-available/teampass.conf
echo "          Require all granted" >> /etc/apache2/sites-available/teampass.conf
echo "     </Directory>" >> /etc/apache2/sites-available/teampass.conf
echo " " >> /etc/apache2/sites-available/teampass.conf
echo "     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log" >> /etc/apache2/sites-available/teampass.conf
echo "     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined" >> /etc/apache2/sites-available/teampass.conf
echo " " >> /etc/apache2/sites-available/teampass.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/teampass.conf





nano /etc/apache2/sites-available/teampass.conf

# redémarrage Teampass
a2ensite teampass
systemctl restart apache2

# verifier status
echo ""
echo "" 
echo -e "\033[32m"
systemctl status apache2 | grep Active:
echo ""
echo ""
read -p "Entrez un touche pour continuer !"
echo -e "\033[00m"
echo ""
echo ""

# Corectif extantion php
sudo apt-get install php-gmp -y


# Open Teampass
apt install lynx -y
rm -f link.html
echo "<!DOCTYPE html>" > link.html
echo "<html>" >> link.html
echo "<body>" >> link.html

echo "<a href="http://localhost/TeamPass/install/install.php">Cliquez ici pour accéder au lien</a>" >> link.html
echo "<p1> Suprimée le repertoire Install qui se situ dans teampass pour vou login aprè la configuration</p1>"
echo "</body>" >> link.html
echo "</html>" >> link.html

systemctl restart apache2


echo -e "Information "
echo -e "ServerAdmin : admin@module300.local"
echo -e "ServerName  : teampass.module300.local"
echo -e "Directory   : /var/www/html/TeamPass"
echo -e "Apache      : apache2"
echo -e "PHP         : php7.4.x"
echo -e "Timezone    : Europe\/Zurich"
echo -e "\033[35mhttp://localhost/TeamPass/install/install.php\033[00m"

# Pour naviger sur la page HTML avec le terminal !
#- lynx link.html

exit
