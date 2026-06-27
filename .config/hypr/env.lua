local env = hl.env

env("QT_QPA_PLATFORM", "wayland")
env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
env("QT_QPA_PLATFORMTHEME", "gtk3")
env("QT_QPA_PLATFORMTHEME_QT6", "gtk3")

env("XCURSOR_SIZE", "24")
env("HYPRCURSOR_SIZE", "24")

local home = os.getenv("HOME")

-- For Zettelkasten (https://github.com/zk-org/zk)
env("ZK_NOTEBOOK_DIR", home .. "/Notes")

-- My custom gpg home
env("GNUPGHOME", home .. "/.kk_home/gnupg")
