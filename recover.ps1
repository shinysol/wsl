<#
.SYNOPSIS
A brief description of your script.

.DESCRIPTION
A more detailed description of what your script does.

.PARAMETER d
Name of distro

#>
param(
	[Parameter(Position=0)]
	[string]$p
)
if (-not $p) {
    wsl --list
    $p = Read-Host "Please enter the name of the distro"
}
& {
    wsl --unregister $p >$null
    Write-Output "Distro $p removed."
    wsl --import-in-place $p ./distros/$p/ext4.vhdx
}