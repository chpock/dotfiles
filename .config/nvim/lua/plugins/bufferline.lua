local function smart_go_to(index)

  if vim.bo.filetype == "neo-tree" then
    -- vim.cmd.wincmd "p"
    local manager = require("neo-tree.sources.manager")
    local state = manager.get_state("filesystem")
    if state and state.tree then
      ---@diagnostic disable-next-line: undefined-field
      local node = state.tree:get_node()
      if node and node.type == "file" then
        _G.neotree_last_path = node:get_id()
      end
    end
    vim.cmd.Neotree "close"
  end
  -- local current_ft = vim.bo.filetype
  -- local current_win1 = vim.api.nvim_get_current_win()
  -- print(string.format("[DEBUG] WinID: %d | Filetype: '%s'", current_win1, current_ft))

  local bufferline = require("bufferline")
  -- 1. Helper to check if a window is a "Safe Editor" (not a plugin sidebar)
  local function is_valid_editor(win_id)
    local config = vim.api.nvim_win_get_config(win_id)
    if config.relative ~= "" then return false end -- Ignore floating windows
    local buf = vim.api.nvim_win_get_buf(win_id)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    -- Add other sidebars here if you use them (e.g. "NvimTree", "aerial")
    local invalid_fts = { "neo-tree", "qf", "outline", "trouble" }
    for _, invalid in ipairs(invalid_fts) do
      if ft == invalid then return false end
    end
    return true
  end

  -- 2. Check: Are we currently in a valid editor?
  local current_win = vim.api.nvim_get_current_win()
  if is_valid_editor(current_win) then
    bufferline.go_to(index, true)
    return
  end

  -- 3. Scan: Find ANY other valid window
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    if is_valid_editor(win_id) then
      vim.api.nvim_set_current_win(win_id)
      bufferline.go_to(index, true)
      return
    end
  end
end

return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      numbers = "ordinal",
      show_buffer_close_icons = false,
      show_close_icon = false,
      tab_size = 0,
    },
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<M-1>"] = { function() smart_go_to(1) end, desc = "Switch to buffer #1" },
            ["<M-2>"] = { function() smart_go_to(2) end, desc = "Switch to buffer #2" },
            ["<M-3>"] = { function() smart_go_to(3) end, desc = "Switch to buffer #3" },
            ["<M-4>"] = { function() smart_go_to(4) end, desc = "Switch to buffer #4" },
            ["<M-5>"] = { function() smart_go_to(5) end, desc = "Switch to buffer #5" },
            ["<M-6>"] = { function() smart_go_to(6) end, desc = "Switch to buffer #6" },
            ["<M-7>"] = { function() smart_go_to(7) end, desc = "Switch to buffer #7" },
            ["<M-8>"] = { function() smart_go_to(8) end, desc = "Switch to buffer #8" },
            ["<M-9>"] = { function() smart_go_to(9) end, desc = "Switch to buffer #9" },
            ["<M-0>"] = { function() smart_go_to(10) end, desc = "Switch to buffer #10" },
          },
          i = {
            ["<M-1>"] = { function() smart_go_to(1) end, desc = "Switch to buffer #1" },
            ["<M-2>"] = { function() smart_go_to(2) end, desc = "Switch to buffer #2" },
            ["<M-3>"] = { function() smart_go_to(3) end, desc = "Switch to buffer #3" },
            ["<M-4>"] = { function() smart_go_to(4) end, desc = "Switch to buffer #4" },
            ["<M-5>"] = { function() smart_go_to(5) end, desc = "Switch to buffer #5" },
            ["<M-6>"] = { function() smart_go_to(6) end, desc = "Switch to buffer #6" },
            ["<M-7>"] = { function() smart_go_to(7) end, desc = "Switch to buffer #7" },
            ["<M-8>"] = { function() smart_go_to(8) end, desc = "Switch to buffer #8" },
            ["<M-9>"] = { function() smart_go_to(9) end, desc = "Switch to buffer #9" },
            ["<M-0>"] = { function() smart_go_to(10) end, desc = "Switch to buffer #10" },
          },
        }
      }
    }
  }
}
