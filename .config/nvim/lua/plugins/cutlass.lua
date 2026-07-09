---@type LazySpec
return {
  "gbprod/cutlass.nvim",
  opts = {
    cut_key = "d",
    override_del = true,
    exclude = {},
    registers = {
      select = "x",
      delete = "x",
      change = "x",
    },
  },
}
