# WSL managing and scripts

- () ignored from repository
```text
WSL
├─ images
│  ├─ (alpine)
│  ├─ (rocky-9)
│  └─ (ubuntu-22.04)
└─ distros
   ├─ (ubuntu-db)
   ├─ (alpine-service)
   └─ (rocky-test)
```

### Prerequisite

- need PowerShell 7+ installed for pf.ps1, pf-end.ps1

### Scripts

- li.ps1: list all images
- ld.ps1: list all distros
- new.ps1: launch new distro by import image
- u.ps1: unregister distro
- d.ps1: attach distro
- pf.ps1: add new ipv4 portforwarding
- pf-end.ps1: delete specific ipv4 portforwarding
- re.ps1: unregister and launch again
- recover.ps1: fix broken storage link(remove and launch)

### change default folder
```PowerShell
nodepad $profile
# or
code $profile
```
- Add to the file this block below
```text
$wslHome = "D:\projects\wsl"
if (-not $env:TERM_PROGRAM -eq "vscode") {
    Set-Location $wslHome
}
```
