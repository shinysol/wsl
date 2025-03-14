<#
.SYNOPSIS
A brief description of your script.

.DESCRIPTION
A more detailed description of what your script does.

.PARAMETER n
Name of distro

.PARAMETER p
Path of image
#>
param(
	[Parameter(Position=0)]
	[string]$n,
	[string]$p
)
if (-not $n) {
    wsl --list
    $n = Read-Host "Please enter the name of the distro"
}
if (-not $p) {
    Get-ChildItem -Path "./images" -Recurse -File | Select-Object FullName | Format-Table -AutoSize | Out-Host
    $p = Read-Host "Please enter the path of the image"
}
& {
wsl --import $n ./distros/$n $p
wsl -d $n
}