local exec = hl.dsp.exec_cmd
local bind = hl.bind

local terminal = "alacritty"
local mainMod  = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

bind(mainMod .. " + return", exec(terminal))

-- Laptop multimedia keys for volume and LCD brightness
bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
bind("XF86AudioMute",        exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
bind("XF86AudioMicMute",     exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
bind("XF86MonBrightnessUp",  exec("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
bind("XF86MonBrightnessDown",exec("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
bind("XF86AudioNext",  exec("playerctl next"),       { locked = true })
bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPlay",  exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPrev",  exec("playerctl previous"),   { locked = true })

-- My shortcuts

bind("CONTROL + grave", exec(table.concat({
    'rofi -show clipboard -modes clipboard,persistent -cycle false -sidebar-mode -kb-custom-1 "Shift+Return" -kb-accept-alt ""',
    '[ ! -e "$XDG_STATE_HOME/rofi/scripts/send-paste" ] || { sleep 0.05; hyprctl dispatch \'hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert", window = "activewindow" })\'; rm -f "$XDG_STATE_HOME/rofi/scripts/send-paste"; }',
}, "; ")))

bind(mainMod .. " + W", exec('dbus-send --type=method_call --dest=org.kde.CrowTranslate /org/kde/CrowTranslate/MainWindow org.kde.CrowTranslate.MainWindow.open'))
bind(mainMod .. " + T", exec('/usr/bin/planify.quick-add'))
bind(mainMod .. " + SHIFT + T", exec('/usr/bin/planify'))
bind(mainMod .. " + N", exec(terminal .. ' --class Neovim -e bash -c "nvim --cmd \\"cd ~/notes\\" -c \\"NeovimProjectLoad ~/notes\\""'))
bind(mainMod .. " + SHIFT + N", exec('/usr/bin/vnote'))
bind(mainMod .. " + E", exec('GNUPGHOME=/home/kot/.kk_home/gnupg EDITOR="vim -u ~/.kk_home/vimrc -i ~/.kk_home/viminfo" ' .. terminal .. ' --class Neovim -e nvim -c NeovimProjectHistory'))
bind(mainMod .. " + space", exec('rofi -modes drun,run,window -show drun -show-icons -cycle false -sidebar-mode -window-format "{c:15} {t}" -display-drun "Applications" -display-run "Run" -display-window "Windows"'))
bind(mainMod .. " + S", exec('rofi -show tmux -modes tmux,ssh -sidebar-mode -cycle false -no-parse-hosts -no-parse-known-hosts -ssh-command \'env _MAGIC_SSH="{host}" SHLVL= ' .. terminal .. ' --class SSH\''))
bind(mainMod .. " + C", exec('rofi -show calc -modes calc -no-show-match -no-sort -automatic-save-to-history -calc-command "echo -n \'{result}\' | wl-copy"'))
bind(mainMod .. " + X", exec('/w/projects/ecoacher/.venv/bin/ecoacher'))

bind("CONTROL + C", exec('~/.local/bin/chrome-wayland-clipboard-copy-workaround.sh'))

bind('Print', exec('/w/projects/hyprsnap/hyprsnap'))

-- Ctrl+Shift (Left or Right) toggles EN <-> RU
local kbswitch_ctrl = '[ "$(hyprctl -j devices | jq \'.keyboards\' | jq \'.[] | select (.main == true) | .active_layout_index\')" -eq 0 ] && echo 1 || echo 0'
bind("SHIFT + CONTROL + Control_L", exec('hyprctl switchxkblayout main $(' .. kbswitch_ctrl .. ')'), { release = true })
bind("SHIFT + CONTROL + Shift_L", exec('hyprctl switchxkblayout main $(' .. kbswitch_ctrl .. ')'), { release = true })

-- Alt+Shift (Left or Right) toggles RU <-> UA (only if not in EN)
local kbswitch_alt = 'L="$(hyprctl -j devices | jq \'.keyboards\' | jq \'.[] | select (.main == true) | .active_layout_index\')"; [ "$L" -eq 0 ] && echo 0 || { [ "$L" -eq 1 ] && echo 2 || echo 1; }'
bind("SHIFT + ALT + Shift_L", exec('hyprctl switchxkblayout main $(' .. kbswitch_alt .. ')'), { release = true })
bind("SHIFT + ALT + Alt_L", exec('hyprctl switchxkblayout main $(' .. kbswitch_alt .. ')'), { release = true })

-- local closeWindowBind = bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
-- bind(mainMod .. " + M", exec("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
-- bind(mainMod .. " + E", exec(fileManager))
-- bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
-- bind(mainMod .. " + R", exec(menu))
-- bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- for i = 1, 10 do
--     local key = i % 10 -- 10 maps to key 0
--     bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
--     bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
-- end
--
-- -- Example special workspace (scratchpad)
-- bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
--
-- -- Scroll through existing workspaces with mainMod + scroll
-- bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
--
