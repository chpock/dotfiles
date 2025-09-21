local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.font_size = 12
-- Cousine Nerd Font Mono is the main console font
-- Other fonts is for fallback in case some
-- symbol is not found in Cousine Nerd Font
config.font = wezterm.font_with_fallback {
   'Cousine Nerd Font Mono',
-- it seems that fallback fonts are added automatically
--   'Noto Color Emoji',
}

config.hide_tab_bar_if_only_one_tab = true

config.scrollback_lines = 10000

-- workaround for bug:
-- https://github.com/wezterm/wezterm/issues/7156
wezterm.on('window-config-reloaded', function(window)
  if wezterm.gui.screens().active.name == 'eDP-1' then
    window:set_config_overrides({
      dpi = 384
    })
  end
end)
-- this was previous solution for the bug:
-- config.dpi = 384.0

-- Enable the scrollbar.
config.enable_scroll_bar = true
config.window_padding = {
    -- value for right is width of scrollbar
    left = 2, right = '1cell',
    top = 0, bottom = 0,
}

config.colors = {
    foreground = "#b2b2b2",
    background = "#000000",
    cursor_border = "#52ad70",
    cursor_bg = "#52ad70",
    cursor_fg = "#ffffff",
    selection_fg = "rgba(0,0,0,0)", -- "#00000000",
    selection_bg = "rgba(127,102,153,127)", -- "#7f66997f",
    visual_bell = "#808080",
    scrollbar_thumb = "#444444",
    split = "#444444",
    ansi =    {"#000000", "#bb0000", "#00bb00", "#bbbb00", "#366ebb", "#bb00bb", "#00bbbb", "#bbbbbb"},
    brights = {"#555555", "#ff5555", "#55ff55", "#ffff55", "#5555ff", "#ff55ff", "#55ffff", "#ffffff"},
}

config.mouse_bindings = {
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = act.CopyTo('Clipboard')
    },
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'SHIFT',
        action = act.CopyTo('Clipboard')
    },
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = act.Multiple({
            act.PasteFrom('Clipboard'),
            act.ClearSelection
        })
    },
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'SHIFT',
        action = act.Multiple({
            act.PasteFrom('Clipboard'),
            act.ClearSelection
        })
    },
}

config.disable_default_key_bindings = true
config.keys = {
    { key = "Insert", mods = "SHIFT", action = act.PasteFrom("Clipboard") },
    { key = "l", mods="SHIFT|CTRL", action="ShowDebugOverlay" },
}

return config
