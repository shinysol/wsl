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

- new.ps1: launch new distro by import
- re.ps1: unregister and launch again
- u.ps1: unregister distro
- d.ps1: attach distro
- port-forwarding: add new ipv4 portforwarding