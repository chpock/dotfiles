return {
  "folke/snacks.nvim",
  opts = function(_, opts)

    opts.dashboard.preset.header = table.concat({
      " █████  ███████ ████████ ██████   ██████ ",
      "██   ██ ██         ██    ██   ██ ██    ██",
      "███████ ███████    ██    ██████  ██    ██",
      "██   ██      ██    ██    ██   ██ ██    ██",
      "██   ██ ███████    ██    ██   ██  ██████ ",
      "",
      "███    ██ ██    ██ ██ ███    ███",
      "████   ██ ██    ██ ██ ████  ████",
      "██ ██  ██ ██    ██ ██ ██ ████ ██",
      "██  ██ ██  ██  ██  ██ ██  ██  ██",
      "██   ████   ████   ██ ██      ██",
    }, "\n")

    local get_icon = require("astroui").get_icon

    opts.dashboard.preset.keys = {
      { key = "d", action = ":NeovimProjectDiscover", icon = get_icon("FolderOpen"), desc = "Project Discover" },
      { key = "h", action = ":NeovimProjectHistory", icon = get_icon("List"), desc = "Project History" },
      { key = "n", action = "<Leader>n", icon = get_icon("FileNew", 0, true), desc = "New File  " },
      { key = "f", action = "<Leader>ff", icon = get_icon("Search", 0, true), desc = "Find File  " },
      { key = "o", action = "<Leader>fo", icon = get_icon("DefaultFile", 0, true), desc = "Recents  " },
      { key = "w", action = "<Leader>fw", icon = get_icon("WordFile", 0, true), desc = "Find Word  " },
      { key = "'", action = "<Leader>f'", icon = get_icon("Bookmarks", 0, true), desc = "Bookmarks  " },
      { key = "s", action = "<Leader>Sl", icon = get_icon("Refresh", 0, true), desc = "Last Session  " },
    }

    opts.picker.layout = {
      -- Don't cycle when navigating through records, it's annoying
      cycle = false,
      layout = {
        -- maximize picker window. I don't see any point in seeing
        -- the underlying windows/layers. It only reduces the visible area.
        width = 0,
        height = 0,
      },
    }

  end,
}
