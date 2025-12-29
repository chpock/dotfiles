-- Official Grafana Alloy plugin is https://github.com/grafana/vim-alloy
-- However, it is poorly updated and https://github.com/jessebot/vim-alloy has more features.
return {
  "jessebot/vim-alloy",
  -- "grafana/vim-alloy",
  event = { "VeryLazy" },
  ft = { "alloy" }, -- lazy-load on Alloy files
  -- lazy = false,
  init = function()
    -- Disable the builtin auto formatting
    vim.g.alloy_fmt_on_save = 0
  end,
}
