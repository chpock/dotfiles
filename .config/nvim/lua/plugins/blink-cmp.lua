-- disable snippets in auto-completion menu

return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}

      -- 1. Disable the built-in global snippets provider (what you already did)
      opts.sources.providers.snippets = { enabled = false }

      -- 2. Filter out snippets sent by LSP servers
      opts.sources.providers.lsp = opts.sources.providers.lsp or {}

      -- Preserve AstroNvim's existing transform_items if it exists
      local base_transform = opts.sources.providers.lsp.transform_items

      opts.sources.providers.lsp.transform_items = function(ctx, items)
        if base_transform then
          items = base_transform(ctx, items)
        end

        -- Filter out items where kind is Snippet (LSP CompletionItemKind.Snippet = 15)
        return vim.tbl_filter(function(item)
          return item.kind ~= vim.lsp.protocol.CompletionItemKind.Snippet
        end, items)
      end
    end,
  },
}
