#################################################################
# Pour les droi d'execution 'Set-ExecutionPolicy Unrestricted'  #
# crée par Kuroakashiro                                         #
#################################################################

# Fichier txt avec DN racine du serveur LDAP
Import-Module ActiveDirectory -ErrorAction SilentlyContinue
if ($? -eq $True) {
    $rootDSE = Get-ADRootDSE -ErrorAction SilentlyContinue
    "####################################" > C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "|---------------------|" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# DN LDAP de TeamPass" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# CN=Users," + $rootDSE.defaultNamingContext >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    $x = Get-ADObject -Filter {Name -eq "Administrateur"} -Properties distinguishedName
    $x = "$x"
    $x = $x -replace ".*?(CN=[^,]+,){2}.*", '$0'
    "|---------------------|" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# Username pour LDAP" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# Examples: cn=administrator,cn=users,dc=ad,dc=example,dc=com ;" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# $x" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "|---------------------|" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# Distinguished Name : distinguishedname " >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "|---------------------|" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# User name attribute : samaccountname" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "|---------------------|" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# User Object Filter : (&(objectCategory=Person)(sAMAccountName=*))" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "|---------------------|" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "# Local and LDAP users : ON" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "|---------------------|" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    "####################################" >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt

    
    New-NetFirewallRule -DisplayName "LDAP" -Direction Inbound -LocalPort 389 -Protocol TCP -Action Allow
    exit
}   
else {
    Write-Host "`nUne fois l'Active Directory installée et le serveur re démarer `nR'executer le script pour avoir `n : DN_racine_du_serveur_LDAP.txt`n"
    $Pause = Read-Host "Entrée une touche pour continuer !"
}



# DomainName
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host "`nEntez le nom de votre domaine !"
    Write-Host "Exemple : example.local"
    [string]$DomainName = Read-Host "► "

    if ($DomainName -notmatch '\.') {
    Write-Host "Le nom de domaine doit contenir au moins un '.' !" -ForegroundColor Red
    }
    else {
        break
    }

}

# DomainNetbiosName
For ([int]$i = 0;$i -lt 1;)
{
    $computerName = $env:COMPUTERNAME
    $computerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computerName
    $netBiosName = $computerSystem.Caption.split()[0]

    clear
    Write-Host "`nEntez le Nom Domain Net bios ci diferant ou fait entrer pour continuer."
    Write-Host "Actuelle celectionée : '$netBiosName'"
    Write-Host "Exemple : EXAMPLE"
    [string]$DomainNetbiosName = Read-Host "► "
    if ($DomainNetbiosName -eq $null) {
        $DomainNetbiosName = "$netBiosName"
        if ($? -eq $True) {
            break
        }
        else {
            Write-Host "Une erreur est survenu '$DomainNetbiosName' -> '$netBiosName'" -ForegroundColor Red
        }
    }
    else {
        $DomainNetbiosName = $DomainNetbiosName.ToUpper()
        if ($? -eq $True) {
            break
        }
        else {
            Write-Host "Une erreur est survenu lord du changement en Majusqule de '$DomainNetbiosName'" -ForegroundColor Red
        }
    }

    
}


# Recapitulatife
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host "`n"
    Write-Host "Récapitulatife" -ForegroundColor Yellow
    Write-Host "---------------"
    Write-Host "DomainName        - $DomainName" -ForegroundColor DarkCyan
    Write-Host "DomainNetbiosName - $DomainNetbiosName" -ForegroundColor DarkCyan
    Write-Host "InstallDns        - True" -ForegroundColor Magenta
    Write-Host "LogPath           - C:\Windows\NTDS" -ForegroundColor Magenta
    Write-Host "SysvolPath        - C:\Windows\SYSVOL" -ForegroundColor Magenta
    Write-Host "DatabasePath      - C:\Windows\NTDS" -ForegroundColor Magenta
    Write-Host "`n"
    Write-Host "[OK] pour continuer !"
    [string]$Validation = Read-Host "► "
    $Validation = $Validation.ToUpper()
    if ($Validation -eq "OK") {
        Write-Host "[OK] `n" -ForegroundColor Green
        break
    }
    else {
        exit
    }
}

# Installation des fonctionnalités d'Active Directory
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Raport
if ($? -eq $True) {
    clear
    "Terminée !" > C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "Récapitulatife" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "---------------" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "DomainName        - $DomainName" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "DomainNetbiosName - $DomainNetbiosName" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "InstallDns        - True" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "LogPath           - C:\Windows\NTDS" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "SysvolPath        - C:\Windows\SYSVOL" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
    "DatabasePath      - C:\Windows\NTDS" >> C:\Users\$env:USERNAME\Desktop\Raport_Installation_AD.txt
}

# Configuration de l'Active Directory
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "$DomainName" `
-DomainNetbiosName "$DomainNetbiosName" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true












