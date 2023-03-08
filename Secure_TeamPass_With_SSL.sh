#!/bin/bash
# Pour Ubuntu ou Debian ! 
# Tuto : https://www.howtoforge.com/how-to-setup-teampass-password-manager-on-debian-11/
##########################################################################################

back=$PWD
localhostIP=$(hostname -I | awk '{print $1}')


# update et install openssl
#-sudo apt-get -y install openssl -y
# Ouvrez un terminal et générez une clé privée :
#-openssl genrsa -out teampass.key 2048
# Générez une demande de signature de certificat (CSR) :
#-openssl req -new -key teampass.key -out teampass.csr
# Une fois la demande de certificat générée, créez un certificat auto-signé à partir de la CSR :
#-openssl x509 -req -days 365 -in teampass.csr -signkey teampass.key -out teampass.crt

# Creation repertoire
#-mkdir /var/www/html/TeamPass/config
#-mkdir /var/www/html/TeamPass/config/certs

# Copy des clé dans le repertoire
#-sudo cp teampass.key teampass.crt

# Redémarage Apache 2
#-sudo systemctl restart apache2

mkdir /etc/ssl/teampass.domaintest.loc/
cd /etc/ssl/teampass.domaintest.loc/

openssl genrsa -out domaintest.loc.ca.key 2048

openssl req -x509 -new -nodes -key domaintest.loc.ca.key -sha256 -days 3650 -out domaintest.loc.ca.cer -subj "/O=DOMAINTEST/CN=DOMAINTEST CA - Certification authority/OU=DOMAINTEST CA - Certification authority"
openssl req -new -sha256 -nodes -out domaintest.loc.csr -newkey rsa:2048 -keyout domaintest.loc.key -subj "/O=DOMAINTEST/CN=teampass.domaintest.loc"




echo "authorityKeyIdentifier=keyid,issuer" > domaintest.loc.sslv3.txt
echo "basicConstraints=CA:FALSE" >> domaintest.loc.sslv3.txt
echo "keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment" >> domaintest.loc.sslv3.txt
echo "subjectAltName = @alt_names" >> domaintest.loc.sslv3.txt
echo "[alt_names]" >> domaintest.loc.sslv3.txt
echo "DNS.1 = teampass.domaintest.loc" >> domaintest.loc.sslv3.txt
echo "DNS.2 = *.domaintest.loc" >> domaintest.loc.sslv3.txt
# DANS
#nano domaintest.loc.sslv3.txt

openssl x509 -req -in domaintest.loc.csr -CAkey domaintest.loc.ca.key -CA domaintest.loc.ca.cer -CAcreateserial -CAserial domaintest.loc.serial -out domaintest.loc.crt -days 3650 -sha256 -extfile domaintest.loc.sslv3.txt

# dans /etc/apache2/sites-available/000-default.conf
# permet de forcéer la conexion en HTTPS
sudo sed -i 's/#ServerName www.example.com/Redirect permanent \/ https:\/\/'"$HOSTNAME"'/' /etc/apache2/sites-available/000-default.conf







#echo "NameVirtualHost teampass.module300.local:443" > /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     DocumentRoot /var/www/html/TeamPass.domaintest.loc" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     ServerName teampass.module300.local" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     #Redirect permanent / https://teampass.domaintest.loc/" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "</VirtualHost>" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "<VirtualHost *:443>" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     ServerAdmin admin@module300.local" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     DocumentRoot /var/www/html/TeamPass" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     #DocumentRoot /var/www/html/teampass.domaintest.loc" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     ServerName teampass.module300.local" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     SSLEngine On" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     SSLCertificateFile /etc/ssl/teampass.domaintest.loc/domaintest.loc.crt" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     SSLCertificateKeyFile /etc/ssl/teampass.domaintest.loc/domaintest.loc.key" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     <Directory /var/www/html/teampass.domaintest.loc>" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "          Options FollowSymlinks" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "          AllowOverride All" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "          Require all granted" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     </Directory>" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf
#echo "</VirtualHost>" >> /etc/apache2/sites-available/teampass.domaintest.loc.conf


# DANS
# nano /etc/apache2/sites-available/teampass.domaintest.loc.conf



echo "NameVirtualHost teampass.module300.local:443" > /etc/apache2/sites-available/teampass.conf
echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/teampass.conf
echo "     DocumentRoot /var/www/html/TeamPass.domaintest.loc" >> /etc/apache2/sites-available/teampass.conf
echo "     ServerName teampass.module300.local" >> /etc/apache2/sites-available/teampass.conf
echo "     #Redirect permanent / https://teampass.domaintest.loc/" >> /etc/apache2/sites-available/teampass.conf
echo "     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log" >> /etc/apache2/sites-available/teampass.conf
echo "     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined" >> /etc/apache2/sites-available/teampass.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/teampass.conf
echo "<VirtualHost *:443>" >> /etc/apache2/sites-available/teampass.conf
echo "     ServerAdmin admin@module300.local" >> /etc/apache2/sites-available/teampass.conf
echo "     DocumentRoot /var/www/html/TeamPass/" >> /etc/apache2/sites-available/teampass.conf
echo "     #DocumentRoot /var/www/html/teampass.domaintest.loc" >> /etc/apache2/sites-available/teampass.conf
echo "     ServerName teampass.module300.local" >> /etc/apache2/sites-available/teampass.conf
echo "     SSLEngine On" >> /etc/apache2/sites-available/teampass.conf
echo "     SSLCertificateFile /etc/ssl/teampass.domaintest.loc/domaintest.loc.crt" >> /etc/apache2/sites-available/teampass.conf
echo "     SSLCertificateKeyFile /etc/ssl/teampass.domaintest.loc/domaintest.loc.key" >> /etc/apache2/sites-available/teampass.conf
echo "     <Directory /var/www/html/TeamPass>" >> /etc/apache2/sites-available/teampass.conf
echo "          Options FollowSymlinks" >> /etc/apache2/sites-available/teampass.conf
echo "          AllowOverride All" >> /etc/apache2/sites-available/teampass.conf
echo "          Require all granted" >> /etc/apache2/sites-available/teampass.conf
echo "     </Directory>" >> /etc/apache2/sites-available/teampass.conf
echo "     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log" >> /etc/apache2/sites-available/teampass.conf
echo "     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined" >> /etc/apache2/sites-available/teampass.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/teampass.conf






#nano /etc/apache2/sites-available/teampass.domaintest.loc.conf


#<VirtualHost *:80>
#     DocumentRoot /var/www/html/TeamPass
#     ServerName teampass.module300.local
#     #Redirect permanent / https://teampass.domaintest.loc/
#     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log
#     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined
#</VirtualHost>
#<VirtualHost *:443>
#     ServerAdmin admin@module300.local
#     DocumentRoot /var/www/html/TeamPass
#     #DocumentRoot /var/www/html/teampass.domaintest.loc
#     ServerName teampass.module300.local
#     SSLEngine On
#     SSLCertificateFile /etc/ssl/teampass.domaintest.loc/domaintest.loc.crt
#     SSLCertificateKeyFile /etc/ssl/teampass.domaintest.loc/domaintest.loc.key
#     <Directory /var/www/html/TeamPass>
#          Options FollowSymlinks
#          AllowOverride All
#          Require all granted
#     </Directory>
#     ErrorLog ${APACHE_LOG_DIR}/teampass_error.log
#     CustomLog ${APACHE_LOG_DIR}/teampass_access.log combined
#</VirtualHost>

# ---------------------------------

a2enmod ssl

# Potentielement inutile 
# ln -s /etc/apache2/sites-available/teampass.domaintest.loc.conf /etc/apache2/sites-enabled/teampass.domaintest.loc.conf

00=0
P53=0
P88=0
P3269=0
P3268=0
P636=0
P389=0
P443=0
P22=0


while true; do
    clear
    echo -e "Sélectionnez les Ports a ouvrire \033[32m[]\033[00m Ouvert \033[31m[]\033[00m Fermer"
    echo -e "Port conseiler 53, 336, 443"
    echo -e "OUVERTURE de Port"
    if [[ $P53 -eq 1 ]]; then echo -e "\033[32m[1] \033[00m   Port : 53   | DNS"; else echo -e "\033[31m[1] \033[00m   Port : 53   | DNS"; fi
    if [[ $P88 -eq 1 ]]; then echo -e "\033[32m[2] \033[00m   Port : 88   | Kerberos"; else echo -e "\033[31m[2] \033[00m   Port : 88   | Kerberos"; fi
    if [[ $P3269 -eq 1 ]]; then echo -e "\033[32m[3] \033[00m   Port : 3269 | LDAPS Catalog"; else echo -e "\033[31m[3] \033[00m   Port : 3269 | LDAPS Catalog"; fi
    if [[ $P3268 -eq 1 ]]; then echo -e "\033[32m[4] \033[00m   Port : 3268 | LDAP Catalog"; else echo -e "\033[31m[4] \033[00m   Port : 3268 | LDAP Catalog"; fi
    if [[ $P636 -eq 1 ]]; then echo -e "\033[32m[5] \033[00m   Port : 636  | LDAPS Secure"; else echo -e "\033[31m[5] \033[00m   Port : 636  | LDAPS Secure"; fi
    if [[ $P389 -eq 1 ]]; then echo -e "\033[32m[6] \033[00m   Port : 389  | LDAP  Non chiffrée"; else echo -e "\033[31m[6] \033[00m   Port : 389  | LDAP  Non chiffrée"; fi
    if [[ $P443 -eq 1 ]]; then echo -e "\033[32m[7] \033[00m   Port : 443  | HTTPS"; else echo -e "\033[31m[7] \033[00m   Port : 443  | HTTPS"; fi
    if [[ $P443 -eq 1 ]]; then echo -e "\033[32m[8] \033[00m   Port : 22  | SSH"; else echo -e "\033[31m[8] \033[00m   Port : 22  | SSH"; fi
    echo -e "\033[33m[9] \033[31mEXIT\033[00m"
    echo ""
    echo ""
    read -p "Entrez le numéro du port que vous souhaitez ajouter : " port_number

    case $port_number in
        1) 
            iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
            P53=1
            Ports[0]="53"
            ;;
        2)
            iptables -A INPUT -p tcp -m tcp --dport 88 -j ACCEPT
            P88=1
            Ports[1]="88"
            ;;
        3)
            iptables -A INPUT -p tcp -m tcp --dport 3269 -j ACCEPT
            P3269=1
            Ports[2]="3269"
            ;;
        4)
            iptables -A INPUT -p tcp -m tcp --dport 3268 -j ACCEPT
            P3268=1
            Ports[3]="3268"
            ;;
        5)
            iptables -A INPUT -p tcp -m tcp --dport 636 -j ACCEPT
            P636=1
            Ports[4]="636"
            ;;
        6)
            iptables -A INPUT -p tcp -m tcp --dport 389 -j ACCEPT
            P389=1
            Ports[5]="389"
            ;;
        7)
            iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
            P443=1
            Ports[6]="443"
            ;;
        8)
            iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
            P22=1
            Ports[7]="22"
            ;;
        9)
            break
            ;;
        *)
            echo "Numéro de port invalide, veuillez réessayer."
            ;;
    esac
done



systemctl restart apache2

apt-get install iptables-persistent -y

#iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -P INPUT DROP

iptables-save

echo "" >> $back/Raport.txt
echo "\033[32mConfiguration SSL pour HTTPS\033[00m" >> $back/Raport.txt
echo "Port, \033[33m22, 80, 443\033[00m Ouvert sur la machine" >> $back/Raport.txt
echo "" >> $back/Raport.txt

echo "" >> $back/Raport.txt
echo "Configuration SSL pour HTTPS" >> $back/Raport.txt
echo -e "Port, ${Ports[0]} ${Ports[1]} ${Ports[2]} ${Ports[3]} ${Ports[4]} ${Ports[5]} ${Ports[6]} ${Ports[7]}  Ouvert sur la machine" >> $back/Raport.txt
echo "Pour acéder a TeamPass HTTPS 'https://localhost' ou 'https://$localhostIP'" >> $back/Raport.txt
echo "" >> $back/Raport.txt
