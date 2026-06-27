local exec = hl.exec_cmd

hl.on("hyprland.start", function ()
    -- Reload plugins
    exec("hyprpm reload -n")
    -- Different set keyboard layout per window
    exec("/usr/bin/hyprland-per-window-layout")
    -- Required for clipboard history integration
    exec("wl-paste --watch cliphist store")
    -- Recommended (must install polkit-mate beforehand) for elevation prompts
    -- This may be a different path on different distributions, the above is for the arch linux mate-polkit package
    exec("/usr/lib/mate-polkit/polkit-mate-authentication-agent-1")
    -- Starts DankShell
    exec("dms run")
    exec("QD_SOURCE_DIR=/w/projects/quickdashboard quickdashboard")
    -- Autostart applications
    exec("/usr/bin/wl-clip-persist --clipboard regular --reconnect-tries 0 --ignore-event-on-error")
    exec('/w/projects/personal-notes/mount.sh "$HOME/.notes-key"')
    exec("/usr/bin/sleep 3 && /usr/bin/Telegram -startintray")
    exec("/usr/bin/sleep 4 && /opt/teams-for-linux/teams-for-linux --minimized true --ozone-platform-hint=auto")
    exec("/usr/bin/sleep 5 && $HOME/.config/teams-for-linux-dxc-envista/run.sh --minimized true --ozone-platform-hint=auto")
    exec("/usr/bin/sleep 6 && /usr/bin/vesktop --start-minimized")
    exec("/usr/bin/sleep 7 && /usr/bin/gpclient launch-gui")
    exec("/usr/bin/sleep 8 && /usr/bin/crow")
    exec("/usr/bin/sleep 9 && /opt/ntfy-desktop/ntfy-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland --hidden")
    exec("/usr/bin/sleep 10 && /w/projects/aws-sso-autologin/run.sh")
end)
