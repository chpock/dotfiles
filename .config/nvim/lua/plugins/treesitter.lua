---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "jsonnet",
      "groovy",
      "qmljs",
      -- add more arguments for adding more treesitter parsers
    },
    highlight = {
      -- treesitter's tmux parser is completelly broken
      -- see also: https://www.reddit.com/r/neovim/comments/1n878sy/tmuxconf_syntax_highlighting_faulty/
      disable = {"tmux"},
    }
  },
}
