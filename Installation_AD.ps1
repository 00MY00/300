#################################################################
# Pour les droi d'execution 'Set-ExecutionPolicy Unrestricted'  #
# crée par Kuroakashiro                                         #
#################################################################


Import-Module ActiveDirectory -ErrorAction SilentlyContinue

if ($? -eq $True) {
    $rootDSE = Get-ADRootDSE -ErrorAction SilentlyContinue
    $rootDSE.defaultNamingContext > C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt
    exit
}   
else {
    Write-Host "`nUne fois l'Active Directory installée et le serveur re démarer `nR'executer le script pour avoir `n : DN_racine_du_serveur_LDAP.txt`n"
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


# Fichier txt avec DN racine du serveur LDAP
Import-Module ActiveDirectory
$rootDSE = Get-ADRootDSE
$rootDSE.defaultNamingContext >> C:\Users\$env:USERNAME\Desktop\DN_racine_du_serveur_LDAP.txt

if ($? -eq $True) {
    clear
    Write-Host "Terminée !" -ForegroundColor Green
    Write-Host "\n"
    Write-Host "Récapitulatife"
    Write-Host "---------------"
    Write-Host "DomainName        - $DomainName"
    Write-Host "DomainNetbiosName - $DomainNetbiosName"
    Write-Host "InstallDns        - True"
    Write-Host "LogPath           - C:\Windows\NTDS"
    Write-Host "SysvolPath        - C:\Windows\SYSVOL"
    Write-Host "DatabasePath      - C:\Windows\NTDS"
    Write-Host "\n"
}





Start-Sleep 20

