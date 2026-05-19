require("autostart")
require("rules")
require("env")
require("bindings")
require("animations")

local hs = require("hyprsplit")
local hy3 = hl.plugin.hy3

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1.6,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hs.config({
    num_workspaces = 10,
    persistent_workspaces = true,
})

hl.config({

     ecosystem = {
        -- Disable donation screen
        no_donation_nag = true
    },

    general = {
        gaps_in  = 5,
        gaps_out = 4,

        border_size = 1,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "hy3",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },

    scrolling = {
        fullscreen_on_one_column = true,
    },

    misc = {
        force_default_wallpaper  = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo    = true,  -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true,
        -- Wake up by keypress
        key_press_enables_dpms   = true,
        -- But don't wake up by mouse events
        mouse_move_enables_dpms  = false,
        -- Don't render windows when lockscreen is active
        session_lock_xray        = false,
        -- Focus window if it wants this
        focus_on_activate        = false,
        -- Enable live reload
        disable_autoreload       = false,
    },

    input = {
        kb_layout  = "us,ru,ua",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = true,
        },
    },

    plugin = {
        hy3 = hy3 ~= nil and {
            tab_first_window = true,
            tabs = {
                border_width = 1,
                colors = {
                    active = "rgba(33ccff20)",
                    active_border = "rgba(33ccffee)",
                    inactive = "rgba(30303020)",
                    inactive_border = "rgba(595959aa)",
                    urgent = "rgba(ff223340)",
                    urgent_border = "rgba(ff2233ee)",
                },
            },
            autotile = {
                enable = true,
                trigger_width = 800,
                trigger_height = 500,
            },
        } or nil,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

if hy3 ~= nil then
    hl.bind(mainMod .. " + SHIFT + Q", hy3.kill_active())
    -- Move focus with mainMod + arrow keys
    hl.bind(mainMod .. " + left",  hy3.move_focus("left"))
    hl.bind(mainMod .. " + right", hy3.move_focus("right"))
    hl.bind(mainMod .. " + up",    hy3.move_focus("up"))
    hl.bind(mainMod .. " + down",  hy3.move_focus("down"))

    hl.bind(mainMod .. " + CONTROL + left",  hy3.move_focus("left", { visible = true, wrap = false }))
    hl.bind(mainMod .. " + CONTROL + right", hy3.move_focus("right", { visible = true, wrap = false }))

    -- Move window with mainMod + SHIFT + arrow keys
    hl.bind(mainMod .. " + SHIFT + left",  hy3.move_window("left", { once = true }))
    hl.bind(mainMod .. " + SHIFT + right", hy3.move_window("right", { once = true }))
    hl.bind(mainMod .. " + SHIFT + up",    hy3.move_window("up", { once = true }))
    hl.bind(mainMod .. " + SHIFT + down",  hy3.move_window("down", { once = true }))
    hl.bind(mainMod .. " + SHIFT + CONTROL + left",  hy3.move_window("left", { once = true, visible = true }))
    hl.bind(mainMod .. " + SHIFT + CONTROL + right", hy3.move_window("right", { once = true, visible = true }))
    hl.bind(mainMod .. " + SHIFT + CONTROL + up",    hy3.move_window("up", { once = true, visible = true }))
    hl.bind(mainMod .. " + SHIFT + CONTROL + down",  hy3.move_window("down", { once = true, visible = true }))
else
    hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
    -- Move focus with mainMod + arrow keys
    hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
end

hl.bind(mainMod .. " + CONTROL + up",    hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + CONTROL + down",  hl.dsp.window.move({ monitor = "-1" }))

if hs ~= nil then
    -- Switch workspaces with mainMod + [0-9]
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key,         hs.dsp.focus({ workspace = i}))
        hl.bind(mainMod .. " + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = true }))
    end
elseif hy3 ~= nil then
    -- Switch workspaces with mainMod + [0-9]
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i}))
        hl.bind(mainMod .. " + SHIFT + " .. key, hy3.move_to_workspace(i))
    end
else
    -- Switch workspaces with mainMod + [0-9]
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i}))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

