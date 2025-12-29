---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  -- AstroNvim uses this plugin to open lazygit with <Leader>gg shortcut.
  -- By default, terminal is float and located in the center of screen.
  -- There is no point in leaving gaps on all sides. So here we will make
  -- the terminal without a border and on all possible space occupied by vim.
  opts = {
    float_opts = {
      border = "none",
      width = function()
          return vim.o.columns
      end,
      height = function()
          return vim.o.lines
      end,
    },
  },
}
