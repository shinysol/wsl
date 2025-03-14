<#
.SYNOPSIS
Launch WSL distributions through a numbered menu
#>

# Get distributions from registry (most reliable method)
$distros = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss" |
           ForEach-Object {
               try {
                   (Get-ItemProperty -Path $_.PSPath -Name DistributionName -ErrorAction Stop).DistributionName
               } catch {
                   Write-Warning "Skipping invalid registry entry: $($_.Exception.Message)"
               }
           } | 
           Where-Object { $_ } |
           Sort-Object  # Sort alphabetically

# Fallback to CLI if registry method fails
if (-not $distros) {
    $distros = (wsl --list --quiet) -split "`r`n" | 
               Where-Object { $_ -match '\S' } | 
               ForEach-Object { $_.Trim() } |
               Sort-Object
}

# Handle empty list
if (-not $distros) {
    Write-Host "🚨 No WSL distributions found!" -ForegroundColor Red
    exit 1
}

# Display menu
Write-Host "`nAvailable WSL Distributions:`n" -ForegroundColor Cyan
for ($i = 0; $i -lt $distros.Count; $i++) {
    Write-Host "$($i+1). $($distros[$i])"
}

# Modified input validation section
do {
    $choice = Read-Host "`nEnter distribution number (1-$($distros.Count))"
    $parsed = $null
    $isValid = [int]::TryParse($choice, [ref]$parsed) -and 
              $parsed -ge 1 -and 
              $parsed -le $distros.Count
    
    if (-not $isValid) {
        Write-Host "❌ Invalid input. Please enter a number between 1 and $($distros.Count)" -ForegroundColor Red
    }
} until ($isValid)

# Launch selected distribution
$selected = $distros[$choice - 1]
Write-Host "`n🚀 Launching $selected..." -ForegroundColor Green

try {
    wsl -d $selected
}
catch {
    Write-Host "`n❌ Failed to launch distribution!" -ForegroundColor Red
    Write-Host "Error: $_"
    Write-Host "`nTroubleshooting steps:`n1. Verify WSL is enabled`n2. Check distribution exists: wsl --list`n3. Try launching manually: wsl -d '$selected'"
}
