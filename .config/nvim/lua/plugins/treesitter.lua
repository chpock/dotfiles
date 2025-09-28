---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "jsonnet",
      "groovy",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
