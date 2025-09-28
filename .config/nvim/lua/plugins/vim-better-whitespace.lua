--- This plugin strips whitespace only on modified lines.

---@type LazySpec
return {
  "ntpeters/vim-better-whitespace",
  -- Don't highlight whitespace on dashboard.
  -- See https://github.com/ntpeters/vim-better-whitespace/issues/172#issuecomment-3099581990
  event = "BufRead",
  config = function()
    local g = vim.g
    g.better_whitespace_enabled = 1
    g.strip_whitespace_on_save = 1
    g.current_line_whitespace_disabled_hard = 0
    g.current_line_whitespace_disabled_soft = 1
    g.strip_max_file_size = 10000
    g.strip_whitespace_confirm = 0
    g.strip_only_modified_lines = 1
    g.better_whitespace_filetypes_blacklist = {"diff", "git", "gitcommit", "unite", "qf", "help", "markdown", "fugitive"}
    g.strip_whitelines_at_eof = 1
    g.better_whitespace_skip_empty_lines = 1
    g.better_whitespace_verbosity = 1
  end,
}
