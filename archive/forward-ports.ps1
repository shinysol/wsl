$wsl_ip = (wsl -d k8s-control-plane hostname -I).Trim()
netsh interface portproxy add v4tov4 listenport=6443 listenaddress=0.0.0.0 connectport=6443 connectaddress=$wsl_ip
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=$wsl_ip
netsh advfirewall firewall add rule name="k8s-ports" dir=in action=allow protocol=TCP localport=6443,80,443