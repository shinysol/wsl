param(
    [Parameter(Position=0)]
    [string]$n,
    [string]$p
)

if (-not $n) {
    wsl --list
    $n = Read-Host "`nPlease enter the name of the distro"
}

if (-not $p) {
    $images = Get-ChildItem -Path "./images" -Recurse -File
    if (-not $images) {
        Write-Error "No WSL images found in ./images directory"
        exit
    }
    
    Write-Host "`nAvailable images:"
    for ($i = 0; $i -lt $images.Count; $i++) {
        Write-Host "$($i+1). $($images[$i].FullName)"
    }
    
    $selection = Read-Host "`nEnter the number of the image to use (1-$($images.Count))"
    $p = $images[[int]$selection - 1].FullName
}

& {
    wsl --import $n ./distros/$n $p
    wsl -d $n
}