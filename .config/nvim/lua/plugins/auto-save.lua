
return {
  {
    "AstroNvim/astrocommunity",
    { import = "astrocommunity.editing-support.auto-save-nvim" },
  },
  {
    "okuuva/auto-save.nvim", -- AstroNvim ships this fork
    opts = {
      -- start disabled globally
      enabled = false,
    },
  },
}
