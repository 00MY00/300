# M300
Script d'installation pour le module de cours 300
# OS utiliser -Debian-

# Commande d'instalation:
    -> apt install git -y
    -> git clone https://github.com/00MY00/300.git # Installe le Repertoire 300 de github
    -> cd 300/  # Entre dans le répertoire
    -> chmod 777 * # Donne les drois d'execution
    -> ./Install_TeamPass.sh # Execute le script



1) Executer la commande d'installation en utilisateur Root.
2) Configurée Teampasse et suprimée le repertoire d'instalation pour pouvoir vous conecter.
3) Executer le script d'activation SSL pour teampass.
4) Executer le script PowerShell pour l'Active Directory sur le serveur Windows.
5) Utilisée le script PowerShell pour le DNS pour crée un DNS pour TeamPass.

# Information
    - L'éxecution des script crée ou ajoute du contenu dans des fichier de Raport. pensée a les lire pour pluse d'aide.

    - Pour crée le DNS relier a TeamPass il sufit de donner l'IP de la machine Debiane pour qu'elle soit accécible.

    - Atention ci le DNS ne fonctionne pas commancer par vidée les cache de navigation. Powershell -> 'Clear-DnsServerCache'.

    - Ci le DNS du serveur Windows ne fonctionne pas ajouter https://DNS pour y accéder cela peu arivée ci le port 80 ets désactivée. 
