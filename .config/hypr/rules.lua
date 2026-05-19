--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local window = hl.window_rule
local layer  = hl.layer_rule

local suppressMaximizeRule = window({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
suppressMaximizeRule:set_enabled(true)

window({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

layer({
    name = "rofi-fast",
    match = { namespace = "^rofi$" },
    no_anim = true,
})

window({
    -- Make crow-translate window float
    name = "crow-translate-float",
    match = {
        class = "^org\\.kde\\.CrowTranslate$",
    },
    stay_focused = true,
    float = true,
})

window({
    -- Make xdg-desktop-portal-gtk window float
    name = "xdg-desktop-portal-gtk-float",
    match = {
        class = "^xdg-desktop-portal-gtk$",
    },
    float = true,
})

window({
    -- Make GlobalProtect VPN window float
    name = "globalprotect-vpn-float",
    match = {
        class = "^(gpgui|gpauth)$",
    },
    float = true,
})

window({
    -- Focus Spotify on activation
    name = "spotify-focus",
    match = {
        class = "^spotify$",
    },
    focus_on_activate = true,
})

layer({
    name = "dms-bar-top-priority",
    match = { namespace = "^dms:bar$" },
    order = 100,
})

layer({
    -- Hide DMS color picker as fast as possible
    -- See: https://github.com/AvengeMedia/DankMaterialShell/issues/1611
    name = "dms-color-picker",
    match = { namespace = "^dms:color-picker$" },
    no_anim = true,
})

-- hl.window_rule({
--     -- Make ecoacher window float
--     name = "ecoacher-float",
--     match = {
--         class = "^ecoacher(-dev)?$",
--     },
--     float = true,
-- })

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
-- hl.window_rule({
--     name  = "move-hyprland-run",
--     match = { class = "hyprland-run" },
--
--     move  = "20 monitor_h-120",
--     float = true,
-- })
