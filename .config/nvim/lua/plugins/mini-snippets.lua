return {
  "echasnovski/mini.snippets",
  opts = function(_, opts)
    -- WHY IT'S NEEDED: AstroNvim pre-configures `opts.snippets` with several built-in loaders (runtime, global, .vscode, etc.).
    -- Simply overwriting `opts.snippets = {}` would wipe them out. Appending to the list via `vim.list_extend` wouldn't work either,
    -- because AstroNvim's original loaders would still execute afterwards, looking for 'bash.json' and causing duplicate lookups.
    --
    -- WHAT IT DOES: It dynamically intercepts all existing loaders and forces them to treat the 'bash' language as 'sh'.
    --
    -- HOW IT DOES IT: It iterates through the populated array of loaders using a loop, wrapping each original loader
    -- function in a custom decorator function that intercepts the incoming context.
    --
    -- WHY IT WORKS: In Lua, functions are first-class citizens. When `mini.snippets` evaluates the loaders for a 'bash' buffer,
    -- our wrapper intercepts the request, mutates the `context.lang` property to 'sh' via `vim.tbl_extend`, and passes
    -- the updated context down to AstroNvim's original loader. This achieves flawless, transparent redirection.
    if opts.snippets then
      for i, original_loader in ipairs(opts.snippets) do
        opts.snippets[i] = function(context)
          if context.lang == "bash" then
            context = vim.tbl_extend("force", context, { lang = "sh" })
          end
          return original_loader(context)
        end
      end
    end
  end,
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          i = {
            [" "] = {
              function()
                local snippets = require("mini.snippets")

                -- Get text before the cursor
                local line = vim.api.nvim_get_current_line()
                local col = vim.api.nvim_win_get_cursor(0)[2]
                local before_cursor = line:sub(1, col)

                -- Generic check: Is there exactly ONE word from the start of the line?
                -- This matches 'if', 'for', 'while', 'case', etc. automatically
                local is_first_word = before_cursor:match("^%s*[%w_-]+$")

                if is_first_word then
                  -- Treesitter protection: Skip if we are inside a comment or a string literal
                  local has_ts, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
                  if has_ts then
                    local node = ts_utils.get_node_at_cursor()
                    -- Treesitter protection: list of node types where snippet expansion is forbidden
                    local forbidden_nodes = { "comment", "string", "heredoc", "char" }
                    if node then
                      local node_type = node:type()

                      -- Iterate through the list of forbidden types
                      for _, forbidden_type in ipairs(forbidden_nodes) do
                        if node_type:find(forbidden_type) then
                          return " "
                        end
                      end
                    end
                  end

                  -- Dry run check: returns a table of matches immediately
                  local matches = snippets.expand({ insert = false })

                  -- In Lua, an empty table {} is truthy, so we must explicitly check its length
                  if matches ~= nil and #matches > 0 then
                    local filtered_matches = {}

                    -- Filter matches to find only those with a description ending in " (auto-expand)"
                    for _, match in ipairs(matches) do
                      if match.desc and match.desc:sub(-14) == " (auto-expand)" then
                        table.insert(filtered_matches, match)
                      end
                    end

                    if #filtered_matches == 1 then
                      -- Exactly one auto-expand snippet found, schedule its precise expansion
                      vim.schedule(function()
                        snippets.expand({
                          -- Override the select function to bypass any UI menus and force-inject our match
                          select = function(_, insert)
                            insert(filtered_matches[1])
                          end
                        })
                      end)
                      return ""
                    elseif #filtered_matches > 1 then
                      -- Multiple auto-expand snippets match; notify the user safely inside vim.schedule
                      vim.schedule(function()
                        vim.notify(
                          "Multiple auto-expand snippets match the current context. Unable to determine which one to expand.",
                          vim.log.levels.ERROR,
                          { title = "mini.snippets" }
                        )
                      end)
                      -- Fallback to inserting a space because the choice is ambiguous
                      return " "
                    end
                  end
                end

                -- Default behavior: just type a space
                return " "
              end,
              expr = true,
              silent = true,
              desc = "Smart global auto-expand snippet on Space",
            },
          },
        },
      },
    },
  },
}
