# WSL autostart on boot

1. Copy `wsl-init.sh` to `/etc`
```
$ sudo cp -f wsl-init.sh /etc
```

1. Install WSLShell service
```
$ ./wsl-install-service.sh <local user account name> <local user account password>
```
