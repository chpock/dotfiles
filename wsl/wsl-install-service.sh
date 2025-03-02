#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: local user accout name or password is not specified" >&2
    echo >&2
    echo "Usage: $0 <local user account name> <local user account password>" >&2
    exit 1
fi

if ! CMD="$(command -v cmd.exe 2>/dev/null)"; then
    echo "Error: could not find cmd.exe" >&2
    exit 1
fi

if ! REG="$(command -v reg.exe 2>/dev/null)"; then
    echo "Error: could not find reg.exe" >&2
    exit 1
fi

# Disable warning:
# CMD.EXE was started with the above path as the current directory.
# UNC paths are not supported.  Defaulting to Windows directory.
echo "Disable cmd.exe warning ..."
(set -x; "$REG" ADD 'HKEY_CURRENT_USER\Software\Microsoft\Command Processor' /v DisableUNCCheck /t REG_DWORD /d 1 /f)

printf "Check for installed NSSM ..."
if "$CMD" /c winget list --id NSSM.NSSM >/dev/null 2>&1; then
    echo " - Installed"
else
    echo " - Not installed"
    echo "Install NSSM ..."
    (set -x; "$CMD" /c winget install --id=NSSM.NSSM -e --accept-source-agreements)
fi

printf "Check for installed WSLShell service ..."
if "$CMD" /c nssm get WSLShell Application >/dev/null 2>&1; then
    echo " - Installed"
else
    echo " - Not installed"
    echo "Install WSLShell service ..."
    (set -x; "$CMD" /c nssm install WSLShell c:/Windows/System32/wsl.exe)
fi

echo "Configure WSLShell service ..."
for ARG in \
    "Start=SERVICE_DELAYED_AUTO_START" \
    "Type=SERVICE_WIN32_OWN_PROCESS" \
    "DisplayName=WSL Shell" \
    "DependOnService=WSLService" \
    "AppPriority=IDLE_PRIORITY_CLASS"
do
    KEY="${ARG%%=*}"
    VAL="${ARG#*=}"
    (set -x; "$CMD" /c nssm set WSLShell "$KEY" "$VAL")
done

echo "Configure WSLShell service credentials as user '$1' ..."
"$CMD" /c nssm set WSLShell ObjectName ".\\$1" "$2"

echo "Start WSLShell service ..."
(set -x; "$CMD" /c nssm start WSLShell)

echo "Enable cmd.exe warning ..."
(set -x; "$REG" DELETE 'HKEY_CURRENT_USER\Software\Microsoft\Command Processor' /v DisableUNCCheck /f)



