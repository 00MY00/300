
# Crée par Kuroakashiro

# IP
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host "`nEntez l'IP v4 de la machine TeamPass !"
    Write-Host "Exemple : 192.168.0.10"
    [string]$IP = Read-Host "► "

    if ($IP -as [ipaddress]) {
        Write-Host "L'adresse IP est valide." -ForegroundColor Green
        Start-Sleep 3
        break
    }
    else {
        Write-Host "L'adresse IP n'est pas valide." -ForegroundColor Red
    }


}

# Name
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host "`nEntez le nom du DNS !"
    Write-Host "Exemple : teampass"
    [string]$Name = Read-Host "► "

    if ([string]::IsNullOrEmpty($Name)) {
        Write-Host "La variable est Vide !" -ForegroundColor Red
    }
    else {
        break
    }

}


# DNS ZoneName
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host ""
    Write-Host "List DNS Server Zone"
    Get-DnsServerZone
    Write-Host ""
    Write-Host "`nEntez le nom de terminaison de zone !"
    Write-Host "Exemple : local"
    [string]$ZoneName = Read-Host "► "

    if ([string]::IsNullOrEmpty($ZoneName)) {
        Write-Host "La variable est Vide !" -ForegroundColor Red
    }
    else {
        break
    }
}

# DNS Name
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host ""
    Write-Host "List DNS Server Zone"
    Get-DnsServerZone
    Write-Host ""
    Write-Host "`nEntez le nom de la zone !"
    Write-Host "Exemple : example"
    [string]$DNSName = Read-Host "► "

    if ([string]::IsNullOrEmpty($DNSName)) {
        Write-Host "La variable est Vide !" -ForegroundColor Red
    }
    else {
        break
    }
}

# Ci besoin creation de la zone dns
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host ""
    Write-Host "List DNS Server Zone"
    Get-DnsServerZone
    Write-Host ""
    Write-Host "Ci vous voulez crée la zone DNS entrée ok cinon laiser vide"
    [string]$Validation = Read-Host "► "
    if ([string]::IsNullOrEmpty($Validation)) {
        break
    }
    else {
        Add-DnsServerPrimaryZone -Name "$DNSName.$ZoneName" -ZoneFile "$DNSName.$ZoneName.dns"
        if ($? -eq $True) {Write-Host "OK"; Start-Sleep 2;}
        break
    }


}

# Recapitulatif
For ([int]$i = 0;$i -lt 1;)
{
    clear
    Write-Host "`n"
    Write-Host "Récapitulatife de l'ajout d'adress DNS" -ForegroundColor Yellow
    Write-Host "---------------"
    Write-Host "IP               - $IP" -ForegroundColor DarkCyan
    Write-Host "Name             - $Name" -ForegroundColor DarkCyan
    Write-Host "ZoneName         - $DNSName.$ZoneName" -ForegroundColor DarkCyan
    Write-Host "TTL              - 01:00:00" -ForegroundColor Magenta
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

# Commande Final
Add-DnsServerResourceRecordA -Name "$Name" -ZoneName "$DNSName.$ZoneName" -IPv4Address "$IP" -TimeToLive 01:00:00

if ($? -eq $True) {
    clear
    Write-Host "`n"
    Write-Host "Récapitulatife de l'ajout d'adress DNS" -ForegroundColor Yellow
    Write-Host "---------------"
    Write-Host "IP               - $IP" -ForegroundColor DarkCyan
    Write-Host "Name             - $Name" -ForegroundColor DarkCyan
    Write-Host "ZoneName         - $DNSName.$ZoneName" -ForegroundColor DarkCyan
    Write-Host "TTL              - 01:00:00" -ForegroundColor Magenta
    Write-Host "`n"
    Write-Host "`n"
    Write-Host "`n"
    $pause = Read-Host "Entrée une touche pour terminer ! "
}

else {
    Write-Host "Code de Fin etrange !"
    Write-Host "Code : $?"
    Write-Host "`n"
    Write-Host "`n"
    Write-Host "Info DNS "
    Get-DnsClientServerAddress
    $pause = Read-Host "Entrée une touche pour terminer ! "
}

Get-DnsServerResourceRecord -ZoneName "$DNSName.$ZoneName"





