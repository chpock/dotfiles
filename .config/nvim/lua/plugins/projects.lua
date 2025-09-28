-- return {
--   {
--     "https://github.com/DrKJeff16/project.nvim",
--     name = "project",
--     opts = {
--       on_attach = function()
--         vim.notify("before_project_selection_callback", vim.log.levels.WARN)
--         return false
--       end,
--       before_attach = function()
--         vim.notify("after_project_selection_callback", vim.log.levels.WARN)
--         return false
--       end,
--     },
--   },
--   {
--     "stevearc/resession.nvim",
--     opts = {
--       autosave = { enabled = true, interval = 60, notify = false },
--     },
--   },
-- }
--

return {
  {
    "https://github.com/coffebar/neovim-project",
    name = "neovim-project",
    opts = {
      projects = { -- define project roots
        "/w/projects/*",
        "/w/projects/envista/*",
        "/w/repositories/*",
        "/w/repositories/envista/*",
        "~/notes",
        "~/.config",
        "~/.config/nvim",
      },
      session_manager_opts = {
        autosave_ignore_dirs = {
          -- vim.fn.expand("~"), -- don't create a session for $HOME/
          "/tmp",
        },
        autosave_ignore_filetypes = {
          -- All buffers of these file types will be closed before the session is saved
          "ccc-ui",
          "gitcommit",
          "gitrebase",
          "qf",
          "toggleterm",
        },
      },
      last_session_on_startup = false,
      picker = {
        type = "snacks", -- one of "telescope", "fzf-lua", or "snacks"
      }
    },
    init = function()
      -- enable saving the state of plugins in the session
      vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- optional picker
      -- { "nvim-telescope/telescope.nvim", tag = "0.1.4" },
      -- optional picker
      -- { "ibhagwan/fzf-lua" },
      -- optional picker
      { "folke/snacks.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
  },
  {
    "Shatur/neovim-session-manager",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
  }
}
