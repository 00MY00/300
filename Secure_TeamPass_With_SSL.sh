#!/bin/bash
# Pour Ubuntu ou Debian ! 
# Tuto : https://www.howtoforge.com/how-to-setup-teampass-password-manager-on-debian-11/

# update et install openssl
sudo apt-get -y install openssl -y
# Ouvrez un terminal et générez une clé privée :
openssl genrsa -out teampass.key 2048
# Générez une demande de signature de certificat (CSR) :
openssl req -new -key teampass.key -out teampass.csr
# Une fois la demande de certificat générée, créez un certificat auto-signé à partir de la CSR :
openssl x509 -req -days 365 -in teampass.csr -signkey teampass.key -out teampass.crt

# Creation repertoire
mkdir /var/www/html/TeamPass/config
mkdir /var/www/html/TeamPass/config/certs

# Copy des clé dans le repertoire
sudo cp teampass.key teampass.crt

# Redémarage Apache 2
sudo systemctl restart apache2






