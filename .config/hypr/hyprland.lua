package.path = "/w/projects/?/init.lua;" .. package.path

require("autostart")
require("rules")
require("env")
require("bindings")
require("animations")

local hs  = require("hyprsplit")
local hyd = require("hyprdeck").setup({ log_level = "info" })

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

    debug = {
        disable_logs = false,
    },

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

        layout = "master",
    },

    master = {
        new_status = "slave",
        new_on_active = "after",
        mfact = 0.70,
        orientation = "left",
    },

    -- These colors were from hy3.
    -- As for now, hyprland doesn't support color for borders and urgent windows in groupbar.
    -- When it be able to support them, these colors can be applied.
    --
    --     tabs = {
    --         border_width = 1,
    --         colors = {
    --             active = "rgba(33ccff20)",
    --             active_border = "rgba(33ccffee)",
    --             inactive = "rgba(30303020)",
    --             inactive_border = "rgba(595959aa)",
    --             urgent = "rgba(ff223340)",
    --             urgent_border = "rgba(ff2233ee)",
    --         },
    --     },
    group = {
        auto_group = true,
        insert_after_current = true,
        focus_removed_window = false,
        group_on_movetoworkspace = true,

        col = {
            border_active   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            border_inactive = "rgba(595959aa)",
            border_locked_active   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            border_locked_inactive = "rgba(595959aa)",
        },

        groupbar = {
            enabled = true,
            render_titles = true,
            scrolling = true,
            middle_click_close = true,

            height = 22,
            font_size = 12,
            font_family = "Sans",
            text_padding = 0,

            -- Render full per-tab backgrounds instead of just the thin indicator line
            gradients = true,
            indicator_height = 0,

            -- Distinct backgrounds: cyan accent for active, dark grey for inactive
            col = {
                active   = "rgba(33ccff30)",
                inactive = "rgba(2a2a2a55)",
            },

            text_color          = "rgba(ffffffdd)",
            text_color_inactive = "rgba(b0b0b0ff)",

            -- Round EACH tab individually (default rounds only the outer edges of the whole bar)
            gradient_rounding = 8,
            gradient_round_only_edges = false,

            -- Visual separator between tabs (acts like the missing per-tab border)
            gaps_in = 8,
            gaps_out = 5,
            keep_upper_gap = false,

            -- Emphasize the focused tab
            font_weight_active = "normal",
            font_weight_inactive = "normal",
        },
    },
    -- master = {
    --     new_status = "master",
    -- },


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
        -- Don't inherit fullscreen state when closing a fullscreen window.
        -- Without this, closing a fullscreen window forces the next active
        -- window (e.g. a tab group) into fullscreen, hiding the groupbar.
        exit_window_retains_fullscreen = false,
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

hl.bind(mainMod .. " + CONTROL + left",  hl.dsp.focus({ monitor = "-1" }))
hl.bind(mainMod .. " + CONTROL + right", hl.dsp.focus({ monitor = "+1" }))

hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())

if hyd ~= nil then
    -- Move focus with mainMod + arrow keys
    hl.bind(mainMod .. " + left",  hyd.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + right", hyd.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + up",    hyd.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + down",  hyd.dsp.focus({ direction = "down" }))
    -- Move window with mainMod + SHIFT + arrow keys
    hl.bind(mainMod .. " + SHIFT + left",  hyd.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. " + SHIFT + right", hyd.dsp.window.move({ direction = "right" }))
    hl.bind(mainMod .. " + SHIFT + up",    hyd.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. " + SHIFT + down",  hyd.dsp.window.move({ direction = "down" }))

    -- Switch workspaces with mainMod + [0-9]
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    hl.bind(mainMod .. " + CONTROL + up",    hyd.dsp.window.move({ monitor = "+1" }))
    hl.bind(mainMod .. " + CONTROL + down",  hyd.dsp.window.move({ monitor = "-1" }))
    for i = 1, 10 do
        local key = i % 10 -- 10 maps to key 0
        hl.bind(mainMod .. " + " .. key,         hyd.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hyd.dsp.window.move({ workspace = i, follow = true }))
    end
else
    -- Move focus with mainMod + arrow keys
    hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

    -- Switch workspaces with mainMod + [0-9]
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    hl.bind(mainMod .. " + CONTROL + up",    hl.dsp.window.move({ monitor = "+1" }))
    hl.bind(mainMod .. " + CONTROL + down",  hl.dsp.window.move({ monitor = "-1" }))

    if hs ~= nil then
        for i = 1, 10 do
            local key = i % 10 -- 10 maps to key 0
            hl.bind(mainMod .. " + " .. key,         hs.dsp.focus({ workspace = i }))
            hl.bind(mainMod .. " + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = true }))
        end
    else
        for i = 1, 10 do
            local key = i % 10 -- 10 maps to key 0
            hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
            hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end
    end
end

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

