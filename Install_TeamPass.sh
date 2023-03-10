#!/bin/bash
# Crée par Kuroakashiro
# Pour Ubuntu ou Debian ! 
# Tuto : https://www.howtoforge.com/how-to-setup-teampass-password-manager-on-debian-11/
# Mise a jour
# Debian sudo user -> su - USERNAM
# Executer le script en Root
back=$PWD
# Teste de conexion Internet
ping -c 1 www.googl.ch > /dev/null 2>&1
if [ $? -eq 0 ];
then
    clear
    echo -e "Internet est joiniable."
elif [ $? -gt 0 ];
then
    clear
    echo -e "Problaime pour accéder a Internet"
    echo -e "Verifier votre DNS"
    ping -c 1 8.8.8.8 > /dev/null 2>&1
    if [ $? -eq 0 ];
    then
        echo -e "le test est concluent verifier votre DNS !"
        read -p "Pause"
        exit
    else
        echo -e "Verifier l'adressage IP, le Par-Feu, le routeur"
        echo -e "Verifier que vous pouvez ping votre Gatewey"
        echo -e "ci votre Gatewey est accésible et votre DNS fonctionne"
        echo -e "Verifier le Par-Feu/Router que vous avez bien un accès a Internet dans votre routage."
        read -p "Pause"
        exit
    fi

else
    echo -e "Problaime pour accéder a Internet"
    echo -e "Verifier l'adressage IP, le Par-Feu, le routeur"
    read -p "Pause" 
    exit 
fi

apt  update -y
apt  upgrade -y
apt install net-tools -y
# Installation des dépandances
#erreur
# apt  install apache2 php7.3 libapache2-mod-php7.3 mysql-server php7.3-mysql php7.3-gd php7.3-mbstring php7.3-xml
apt install apache2 apache2-utils mariadb-server mariadb-client php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline php7.4-bcmath php7.4-curl php7.4-fpm php7.4-gd php7.4-xml php7.4-mbstring -y
apt install php7.4-gmp -y
apt install php-ldap -y

# -------------------- 04.03.2023
# installation de LDAP
clear
echo ""
echo ""
echo -e "\033[35mVous allez devoir entrer le MOT de Passe pour l'administrateur LDAP\033[00m"
echo ""
read -p "Entrez une touche pour continuer !"
apt install slapd ldap-utils -y
echo ""
# Status de LDAP
clear
echo ""
echo ""
echo -e "\033[32m"
systemctl status slapd | grep 'Active: active'
if [ $? -gt 0 ]; # ci pas démarer re démare
then
    systemctl start slapd
    systemctl status slapd | grep 'Active: active'
fi
echo -e "\033[00m"
read -p "Entrez une touche pour continuer !"

# Démarage LDAP automatique
systemctl enable slapd

# configuration UTF-8 LDAP client
echo -e "\n# Set the default encoding to UTF-8\nUTF8" | sudo tee -a /etc/ldap/ldap.conf
sudo systemctl restart slapd


# -------------------- 04.03.2023 END

# Change setings
# max_execution_time = 60
# date.timezone = Europ/Zurich
# Potentielement il faudrais retirer le ';' avent openssl
sed -i 's/ax_execution_time = 30/ax_execution_time = 60/g' /etc/php/7.4/apache2/php.ini
sed -i 's/;date.timezon =/date.timezon = Europe\/Zurich/g' /etc/php/7.4/apache2/php.ini
sed -i 's/;extension=gmp/extension=gmp/g' /etc/php/7.4/apache2/php.ini
sed -i 's/;extension=php_ldap.dll/extension=php_ldap.dll/g' /etc/php/7.4/apache2/php.ini
apt install php-ldap -y

# nano /etc/php/7.4/apache2/php.ini

# Restart Apache2
systemctl restart apache2

# Add MDP on MariaDB
mysql_secure_installation



# Login SQL
echo ""
echo ""
echo "Copier et clik droit !"
echo -e "\033[35m________________________________________\033[00m"
echo -e "\033[32mcreate database teampass;"
echo -e "\033[32mgrant all privileges on teampass.* to teampass@localhost identified by 'password';\033[00m"
echo -e "\033[32mflush privileges;"
echo -e "\033[32mexit;\033[00m"
echo -e "\033[35m________________________________________\033[00m"
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
echo "<VirtualHost *:443>" >> /etc/apache2/sites-available/teampass.conf
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





# nano /etc/apache2/sites-available/teampass.conf

# redémarrage Teampass
a2ensite teampass
systemctl restart apache2

# verifier status
echo ""
echo "" 
echo -e "\033[32m"
systemctl status apache2 | grep 'Active: active'
if [ $? -gt 0 ]; # ci pas démarer re démare
then
    systemctl start slapd
    systemctl status slapd | grep 'Active: active'
fi
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
echo "<p1> Suprimée le repertoire Install qui ce situ dans teampass pour vou login aprè la configuration</p1>"
echo "</body>" >> link.html
echo "</html>" >> link.html

systemctl restart apache2

echo -e "\033[33m"
echo -e "Information "
echo -e "ServerAdmin : admin@module300.local"
echo -e "ServerName  : teampass.module300.local"
echo -e "Directory   : /var/www/html/TeamPass"
echo -e "Apache      : apache2"
echo -e "PHP         : php7.4.x"
echo -e "Timezone    : Europe\/Zurich"
echo -e "\033[35mhttp://localhost/TeamPass/install/install.php\033[00m"
echo -e "-----------------------"
echo -e "Pour la supretion du fichier d'installation !"
echo -e "rm -rf /var/www/html/TeamPass/install/"
echo -e "-----------------------"
echo -e "LDAP"
echo -e "Hosts         : IP server Active Directory"
echo -e "LDAP port     : 389"
echo -e "Base DN       : Se trouve dans le bureau windows server"
echo -e "              : DN_racine_du_serveur_LDAP.txt"
echo ""
echo -e "\033[31mIl serais bien de redémarer le système pour apliquer les changements"
echo -e "Suprimée le repertoire Install qui ce situ dans teampass pour vou login aprè la configuration\033[00m"
################################################
#Ouvrez l'interface de configuration de Teampass en accédant à l'URL d'installation de l'application dans votre navigateur.
#Accédez à l'onglet "LDAP" dans le menu de gauche.
#Remplissez les champs du formulaire LDAP, tels que :
#Serveur LDAP : L'adresse IP ou le nom de domaine complet (FQDN) du serveur LDAP.
#Port LDAP : Le port LDAP sur lequel le serveur écoute (le port LDAP standard est 389).
#Version LDAP : La version du protocole LDAP que le serveur utilise.
#DN racine : Le DN (distinguished name) racine de l'arborescence LDAP.
#Nom d'utilisateur et mot de passe : Les informations d'identification d'un compte LDAP ayant des privilèges suffisants pour accéder à l'annuaire LDAP.
#Enregistrez les modifications et testez la connexion LDAP en cliquant sur le bouton "Tester la connexion LDAP".
################################################

# Pour naviger sur la page HTML avec le terminal !
#- lynx link.html

# -------------------- 04.03.2023
echo -e "Information " > $back/Raport.txt
echo -e "ServerAdmin : admin@module300.local" >> $back/Raport.txt
echo -e "ServerName  : teampass.module300.local" >> $back/Raport.txt
echo -e "Directory   : /var/www/html/TeamPass" >> $back/Raport.txt
echo -e "Apache      : apache2" >> $back/Raport.txt
echo -e "PHP         : php7.4.x" >> $back/Raport.txt
echo -e "Timezone    : Europe\/Zurich" >> $back/Raport.txt
echo -e "\033[35mhttp://localhost/TeamPass/install/install.php\033[00m" >> $back/Raport.txt
echo -e "-----------------------" >> $PWD/Raport.txt
echo -e "Pour la supretion du fichier d'installation !" >> $back/Raport.txt
echo -e "rm -rf /var/www/html/TeamPass/install/" >> $back/Raport.txt
echo -e "-----------------------" >> $back/Raport.txt
echo -e "LDAP" >> $back/Raport.txt
echo -e "Hosts         : IP server Active Directory" >> $back/Raport.txt
echo -e "LDAP port     : 389" >> $back/Raport.txt
echo -e "Base DN       : Se trouve dans le bureau windows server" >> $back/Raport.txt
echo -e "              : DN_racine_du_serveur_LDAP.txt" >> $back/Raport.txt
echo "" >> $back/Raport.txt
echo -e "Suprimée le repertoire Install qui ce situ dans teampass pour vou login aprè la configuration" >> $back/Raport.txt
echo -e "Une fois TeamPass configurée executer 'Secure TeamPass Whith SSL.sh' Pour activer le https " >> $back/Raport.txt
echo -e "Oublier pas d'executer les script PS1 sur un serveur Windows pour avoir un Active Directory et crée un DNS" >> $back/Raport.txt
# -------------------- 04.03.2023 END


exit
