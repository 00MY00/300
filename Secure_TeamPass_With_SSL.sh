#!/bin/bash
# Pour Ubuntu ou Debian ! 
# Tuto : https://www.howtoforge.com/how-to-setup-teampass-password-manager-on-debian-11/
##########################################################################################

# Variable
back=$PWD
localhostIP=$(hostname -I | awk '{print $1}')


# Creation du répertoire
mkdir /etc/ssl/teampass.domaintest.loc/

# Aller dans le bon répertoire 
cd /etc/ssl/teampass.domaintest.loc/

# Creation des clé RSA
openssl genrsa -out domaintest.loc.ca.key 2048
# Ajout d'information au sertificat
openssl req -x509 -new -nodes -key domaintest.loc.ca.key -sha256 -days 3650 -out domaintest.loc.ca.cer -subj "/O=DOMAINTEST/CN=DOMAINTEST CA - Certification authority/OU=DOMAINTEST CA - Certification authority"
openssl req -new -sha256 -nodes -out domaintest.loc.csr -newkey rsa:2048 -keyout domaintest.loc.key -subj "/O=DOMAINTEST/CN=teampass.domaintest.loc"



# Fichier d'information du sertificat
echo "authorityKeyIdentifier=keyid,issuer" > domaintest.loc.sslv3.txt
echo "basicConstraints=CA:FALSE" >> domaintest.loc.sslv3.txt
echo "keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment" >> domaintest.loc.sslv3.txt
echo "subjectAltName = @alt_names" >> domaintest.loc.sslv3.txt
echo "[alt_names]" >> domaintest.loc.sslv3.txt
echo "DNS.1 = teampass.domaintest.loc" >> domaintest.loc.sslv3.txt
echo "DNS.2 = *.domaintest.loc" >> domaintest.loc.sslv3.txt

# Signature des certificat avec la clé RSA et les informations
openssl x509 -req -in domaintest.loc.csr -CAkey domaintest.loc.ca.key -CA domaintest.loc.ca.cer -CAcreateserial -CAserial domaintest.loc.serial -out domaintest.loc.crt -days 3650 -sha256 -extfile domaintest.loc.sslv3.txt

# dans /etc/apache2/sites-available/000-default.conf
# permet de forcéer la conexion en HTTPS
sudo sed -i 's/#ServerName www.example.com/Redirect permanent \/ https:\/\/'"$localhostIP"'/' /etc/apache2/sites-available/000-default.conf

# Changement de la conffige
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








# ---------------------------------
# Activation SSL de apache2
a2enmod ssl

# Variable pour le Par-Feu pour changer les couleurs
00=0
P53=0
P88=0
P3269=0
P3268=0
P636=0
P389=0
P443=0
P22=0
P80=0
P3306=0

# Installation de Iptable
apt-get install iptables-persistent -y

# Choi des règle du Par-feu
while true; do
    clear
    echo -e "Sélectionnez les Ports a ouvrire \033[32m[]\033[00m Ouvert \033[31m[]\033[00m Fermer"
    echo -e "Port conseiler 53, 3306, 443, 80"
    echo -e "OUVERTURE de Port"
    if [[ $P53 -eq 1 ]]; then echo -e "\033[32m[1] \033[00m   Port : 53   | DNS"; else echo -e "\033[31m[1] \033[00m   Port : 53   | DNS"; fi
    if [[ $P88 -eq 1 ]]; then echo -e "\033[32m[2] \033[00m   Port : 88   | Kerberos"; else echo -e "\033[31m[2] \033[00m   Port : 88   | Kerberos"; fi
    if [[ $P3269 -eq 1 ]]; then echo -e "\033[32m[3] \033[00m   Port : 3269 | LDAPS Catalog"; else echo -e "\033[31m[3] \033[00m   Port : 3269 | LDAPS Catalog"; fi
    if [[ $P3268 -eq 1 ]]; then echo -e "\033[32m[4] \033[00m   Port : 3268 | LDAP Catalog"; else echo -e "\033[31m[4] \033[00m   Port : 3268 | LDAP Catalog"; fi
    if [[ $P636 -eq 1 ]]; then echo -e "\033[32m[5] \033[00m   Port : 636  | LDAPS Secure"; else echo -e "\033[31m[5] \033[00m   Port : 636  | LDAPS Secure"; fi
    if [[ $P389 -eq 1 ]]; then echo -e "\033[32m[6] \033[00m   Port : 389  | LDAP  Non chiffrée"; else echo -e "\033[31m[6] \033[00m   Port : 389  | LDAP  Non chiffrée"; fi
    if [[ $P443 -eq 1 ]]; then echo -e "\033[32m[7] \033[00m   Port : 443  | HTTPS"; else echo -e "\033[31m[7] \033[00m   Port : 443  | HTTPS"; fi
    if [[ $P22 -eq 1 ]]; then echo -e "\033[32m[8] \033[00m   Port : 22   | SSH"; else echo -e "\033[31m[8] \033[00m   Port : 22   | SSH"; fi
    if [[ $P80 -eq 1 ]]; then echo -e "\033[32m[9] \033[00m   Port : 80   | HTTP"; else echo -e "\033[31m[9] \033[00m   Port : 80   | HTTP"; fi
    if [[ $P3306 -eq 1 ]]; then echo -e "\033[32m[10] \033[00m   Port : 3306 | HTTP"; else echo -e "\033[31m[10] \033[00m   Port : 3306 | HTTP"; fi
    echo -e "\033[35m------------------\033[00m"
    echo -e "\033[33m[11] \033[31mEXIT\033[00m"
    echo ""
    echo ""
    read -p "Entrez le numéro du port que vous souhaitez ajouter : " port_number

    case $port_number in
        1) 
            if [[ $P53 -eq 1 ]]; 
            then 
                P53=0
                iptables -D INPUT -p tcp -m tcp --dport 53 -j ACCEPT
                Ports[0]=""
            else 
                P53=1
                iptables -A INPUT -p tcp -m tcp --dport 53 -j ACCEPT
                Ports[0]="53"
            fi
            ;;
        2)
            if [[ $P88 -eq 1 ]]; 
            then 
                P88=0
                iptables -D INPUT -p tcp -m tcp --dport 88 -j ACCEPT
                Ports[1]=""
            else 
                P88=1
                iptables -A INPUT -p tcp -m tcp --dport 88 -j ACCEPT
                Ports[1]="88"
            fi
            ;;
        3)
            if [[ $P3269 -eq 1 ]]; 
            then 
                P3269=0
                iptables -D INPUT -p tcp -m tcp --dport 3269 -j ACCEPT
                Ports[2]=""
            else 
                P3269=1
                iptables -A INPUT -p tcp -m tcp --dport 3269 -j ACCEPT
                Ports[2]="3269"
            fi
            ;;
        4)
            if [[ $P3268 -eq 1 ]]; 
            then 
                P3268=0
                iptables -D INPUT -p tcp -m tcp --dport 3268 -j ACCEPT
                Ports[3]=""
            else 
                P3268=1
                iptables -A INPUT -p tcp -m tcp --dport 3268 -j ACCEPT
                Ports[3]="3268"
            fi
            ;;
        5)
            if [[ $P636 -eq 1 ]]; 
            then 
                P636=0
                iptables -D INPUT -p tcp -m tcp --dport 636 -j ACCEPT
                Ports[4]=""
            else 
                P636=1
                iptables -A INPUT -p tcp -m tcp --dport 636 -j ACCEPT
                Ports[4]="636"
            fi
            ;;
        6)
            if [[ $P389 -eq 1 ]]; 
            then 
                P389=0
                iptables -D INPUT -p tcp -m tcp --dport 389 -j ACCEPT
                Ports[5]=""
            else 
                P389=1
                iptables -A INPUT -p tcp -m tcp --dport 389 -j ACCEPT
                Ports[5]="389"
            fi
            ;;
        7)
            if [[ $P443 -eq 1 ]]; 
            then 
                P443=0
                iptables -D INPUT -p tcp -m tcp --dport 443 -j ACCEPT
                Ports[6]=""
            else 
                P443=1
                iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
                Ports[6]="443"
            fi
            ;;
        8)
            if [[ $P22 -eq 1 ]]; 
            then 
                P22=1
                iptables -D INPUT -p tcp -m tcp --dport 22 -j ACCEPT
                Ports[7]=""
            else 
                P22=1
                iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
                Ports[7]="22"
            fi
            ;;
        9)
            if [[ $P80 -eq 1 ]]; 
            then 
                P80=1
                iptables -D INPUT -p tcp -m tcp --dport 80 -j ACCEPT
                Ports[8]=""
            else 
                P80=1
                iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
                Ports[8]="80"
            fi
            ;;
        9)
            if [[ $P3306 -eq 1 ]]; 
            then 
                P3306=1
                iptables -D INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
                Ports[9]=""
            else 
                P3306=1
                iptables -A INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
                Ports[9]="3306"
            fi
            ;;
        11)
            clear
            break
            ;;
        *)
            echo "Numéro de port invalide, veuillez réessayer."
            ;;
    esac
done


# Redémarage du service apache2
systemctl restart apache2



# Activation et sauvegard des regle configurée
iptables -A INPUT -i lo -j ACCEPT
iptables -P INPUT DROP
# 10.03.23
iptables-save > /etc/iptables/rules.v4
iptables-restore < /etc/iptables/rules.v4
systemctl enable iptables.service


# raport de l'execution du script
echo "" >> $back/Raport.txt
echo "\033[32mConfiguration SSL pour HTTPS\033[00m" >> $back/Raport.txt
echo "Port, \033[33m22, 80, 443\033[00m Ouvert sur la machine" >> $back/Raport.txt
echo "" >> $back/Raport.txt

echo "" >> $back/Raport.txt
echo "Configuration SSL pour HTTPS" >> $back/Raport.txt
echo -e "Port, ${Ports[0]} ${Ports[1]} ${Ports[2]} ${Ports[3]} ${Ports[4]} ${Ports[5]} ${Ports[6]} ${Ports[7]} ${Ports[8]} ${Ports[9]}  Ouvert sur la machine" >> $back/Raport.txt
echo "Pour acéder a TeamPass HTTPS 'https://localhost' ou 'https://$localhostIP'" >> $back/Raport.txt
echo "" >> $back/Raport.txt
