-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  -- import/override with your plugins folder
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.hyprlang" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.docker" },
  -- { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.recipes.neovide" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.bigfile-nvim" }, -- LunarVim/bigfile.nvim Make editing big files faster
  -- { import = "astrocommunity.fuzzy-finder.telescope-nvim" },
  { import = "astrocommunity.recipes.heirline-mode-text-statusline" },
  { import = "astrocommunity.recipes.diagnostic-virtual-lines-current-line" },
  { import = "astrocommunity.bars-and-lines.bufferline-nvim" },
  { import = "astrocommunity.utility.live-preview" },
  -- { import = "astrocommunity.ai.opencode-nvim" },
  { import = "astrocommunity.ai.sidekick-nvim" },
  { import = "astrocommunity.snippet.mini-snippets" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  -- { import = "astrocommunity.motion.flash-nvim" },
  --- only for practice
  { import = "astrocommunity.workflow.hardtime-nvim" },
  -- { import = "astrocommunity.workflow.precognition-nvim" },
  -- { import = "astrocommunity.editing-support.undotree" },
  -- { import = "astrocommunity.search.nvim-hlslens" },
  -- { import = "astrocommunity.pack.harper" },
  -- { import = "astrocommunity.utility.noice-nvim" },
  -- {
  --   "gruvbox.nvim",
  --   opts = {
  --     background = "dark",
  --     contrast = "hard",
  --   },
  -- },
}
