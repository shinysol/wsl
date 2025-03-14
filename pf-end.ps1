# Require administrative privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Get port forwarding rules
$rules = netsh interface portproxy show all | Where-Object { $_ -match '\d+\.\d+\.\d+\.\d+' } | ForEach-Object {
    $parts = $_ -split '\s+'
    [PSCustomObject]@{
        ListenAddress = $parts[0]
        ListenPort = $parts[1]
        ConnectAddress = $parts[2]
        ConnectPort = $parts[3]
    }
}

# Display rules
if ($rules.Count -eq 0) {
    Write-Host "No port forwarding rules found."
    exit
}

Write-Host "`nPort Forwarding Rules:"
$index = 1
$rules | ForEach-Object {
    Write-Host "$index. Listen: $($_.ListenAddress):$($_.ListenPort) → Connect: $($_.ConnectAddress):$($_.ConnectPort)"
    $index++
}

# Get user selection
$selection = Read-Host "`nEnter rule number to remove (1-$($rules.Count))"
try {
    $selectedRule = $rules[[int]$selection - 1]
}
catch {
    Write-Host "Invalid selection." -ForegroundColor Red
    exit
}

# Delete selected rule
netsh interface portproxy delete v4tov4 listenport=$($selectedRule.ListenPort) listenaddress=$($selectedRule.ListenAddress)

# Verify deletion
$remaining = netsh interface portproxy show all
if ($remaining -match "$($selectedRule.ListenAddress)\s+$($selectedRule.ListenPort)") {
    Write-Host "Failed to remove rule." -ForegroundColor Red
} else {
    Write-Host "Successfully removed rule: $($selectedRule.ListenAddress):$($selectedRule.ListenPort)" -ForegroundColor Green
}