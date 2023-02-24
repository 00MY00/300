# DomainName
For ([int]$i = 0;$i -lt 1;)
{
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
    Write-Host "`nEntez le Nom Domain Net bios !"
    Write-Host "Exemple : EXAMPLE"
    [string]$DomainNetbiosName = Read-Host "► "
    $DomainNetbiosName = $DomainNetbiosName.ToUpper()
    if ($? -eq $True) {
        break
    }
    else {
        Write-Host "Une erreur est survenu lord du changement en Majusqule de '$DomainNetbiosName'" -ForegroundColor Red
    }
}


# Recapitulatife
For ([int]$i = 0;$i -lt 1;)
{
    Write-Host "`n"
    Write-Host "RÃ©capitulatife" -ForegroundColor Yellow
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

# Installation des fonctionnalitÃ©s d'Active Directory
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


if ($? -eq $True) {
    clear
    Write-Host "TerminÃ©e !" -ForegroundColor Green
    Write-Host "\n"
    Write-Host "RÃ©capitulatife"
    Write-Host "---------------"
    Write-Host "DomainName        - $DomainName"
    Write-Host "DomainNetbiosName - $DomainNetbiosName"
    Write-Host "InstallDns        - True"
    Write-Host "LogPath           - C:\Windows\NTDS"
    Write-Host "SysvolPath        - C:\Windows\SYSVOL"
    Write-Host "DatabasePath      - C:\Windows\NTDS"
    Write-Host "\n"
}








