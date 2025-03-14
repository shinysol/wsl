<#
.SYNOPSIS
A brief description of your script.

.DESCRIPTION
A more detailed description of what your script does.

.PARAMETER lp
Listen Port

.PARAMETER la
Listen Address

.PARAMETER dp
Destination Port

.PARAMETER da
Destination Address
#>

param(
	[Parameter(Position=0)]
	[string]$lp,
	[string]$la,
    [string]$dp,
	[string]$da
)
function Test-AdminPrivileges {
    return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
if (Test-AdminPrivileges) {
    Write-Host "Running as administrator"
} else {
    Write-Host "Not running as administrator"
    Start-Process pwsh -Verb RunAs -ArgumentList "./pf.ps1"
    exit
}
netsh interface portproxy show all
if (-not $lp) {
    $lp = Read-Host "Please enter the listening port"
}
if (-not $la) {
    $la = Read-Host "Please enter the listening address(default 0.0.0.0)"
    if ([string]::IsNullOrWhiteSpace($la)) {
        $la = "0.0.0.0"
    }
}
if (-not $dp) {
    $dp = Read-Host "Please enter the destination port(default same for lp)"
    if ([string]::IsNullOrWhiteSpace($dp)) {
        $dp = $lp
    }
}
if (-not $da) {
    $da = Read-Host "Please enter the destination address(default WSL IP)" 
    if ([string]::IsNullOrWhiteSpace($da)) {
        $da = (wsl hostname -I).Trim().Split()[0]
    }
}


netsh interface portproxy add v4tov4 listenport=$lp listenaddress=$la connectport=$dp connectaddress=$da
netsh interface portproxy show all