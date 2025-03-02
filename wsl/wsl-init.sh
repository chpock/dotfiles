#!/bin/sh

set -e

(

for WIN_PATH in /c/Windows /mnt/c/Windows /usr/bin/windows; do
    if [ -x "$WIN_PATH/System32/wsl.exe" ]; then
        WSL_BIN="$WIN_PATH/System32/wsl.exe"
    echo "Use wsl.exe: $WSL_BIN"
    fi
    if [ -x "$WIN_PATH/System32/WindowsPowerShell/v1.0/powershell.exe" ]; then
        POWERSHELL_BIN="$WIN_PATH/System32/WindowsPowerShell/v1.0/powershell.exe"
    echo "Use powershell.exe: $POWERSHELL_BIN"
    fi
done

# Mount required disks

if [ -z "$WSL_BIN" ]; then
    echo "ERROR: wsl.exe not found"
else
    # --mount generates an error if the disk is already mounted. So, let's ignore this error.
    (set -x; "$WSL_BIN" --mount --vhd C:/Users/kot/disks/projects.vhdx --bare) || true
    (set -x; "$WSL_BIN" --mount --vhd C:/Users/kot/disks/repositories.vhdx --bare) || true
fi

# Enable a firewall rule for SSH externally for sshd in WSL

if [ -z "$POWERSHELL_BIN" ]; then
    echo "ERROR: powershell not found"
else
    (set -x; "$POWERSHELL_BIN" -c 'if (-not (Get-NetFirewallHyperVRule -Name "WSL sshd" -ErrorAction SilentlyContinue)) { New-NetFirewallHyperVRule -Name "WSL sshd" -DisplayName "WSL SSH daemon" -Direction Inbound -VMCreatorId "{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}" -Protocol TCP -LocalPorts 22 }')
fi

) 2>&1 | sudo tee /var/log/wsl-init.log

exec cat

