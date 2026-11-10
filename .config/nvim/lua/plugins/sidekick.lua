---@type LazySpec
return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      mux = {
        -- Run Pi directly in Neovim's terminal instead of through tmux.
        -- With Neovim 0.12.6 and tmux 3.8, tmux requests modifyOtherKeys,
        -- which Neovim's embedded terminal does not implement: Shift+Enter
        -- becomes plain Enter before reaching Pi. Without tmux, Pi negotiates
        -- the supported Kitty keyboard protocol and keeps Shift+Enter distinct.
        --
        -- Process persistence is neither needed nor desired here. Pi in Sidekick
        -- is part of the editor, so its process should stop when Neovim closes.
        -- Each CWD reopens the dedicated "Neovim integration" session via the
        -- stable --session-id below; its saved conversation history survives
        -- closing the editor and is resumed on the next launch.
        -- Keeping Pi running after Neovim exits would violate this lifecycle,
        -- so leave the multiplexer disabled even if the keyboard issue is fixed.
        enabled = false,
      },
      prompts = {
        translate = "Translate {this} into English and reformat it for readability, preserving the original meaning",
      },
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)
    -- Intentionally replace all CLI tools after setup: Pi is the only coding agent I use.
    require("sidekick.config").cli.tools = {
      pi = {
        -- Reuse a dedicated Pi session for the current CWD, creating it if missing.
        -- The stable ID selects the session; --name sets its display name.
        cmd = {
          "pi",
          "--session-id",
          "neovim-integration",
          "--name",
          "Neovim integration",
        },
      },
    }
  end,
}
