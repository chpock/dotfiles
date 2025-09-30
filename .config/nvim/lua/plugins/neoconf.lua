---@types LazySpec
return {
  "folke/neoconf.nvim",
  opts = {
    import = {
      -- Do not import .vscode/settings.json file. This can lead to unexpected issues.
      -- For example, I had issues with gopls. Its settings are defined in neovim like:
      --   gopls { codelenses = ..., usePlaceholders = ..., ... }
      -- but in .vscode/settings.json file they are defined as:
      --   gopls { "ui.codelenses" = ..., "ui.completion.usePlaceholders" = ..., ... }
      -- This leads to duplicated settings after neoconf merge nvim and vscode settings,
      -- and the following runtime error for gopls:
      --   LSP[gopls] Invalid settings: duplicate value for codelenses; duplicate value for gofumpt; duplicate value for semanticTokens; duplicate value for usePlaceholders
      -- In order to avoid this issue, vscode settings must be disabled.
      vscode = false,
      coc = true,
      nlsp = true,
    },
  },
}
