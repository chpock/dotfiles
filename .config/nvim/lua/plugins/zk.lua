local function is_zk_note(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return false
  end

  local ok, zk_util = pcall(require, "zk.util")
  if not ok or zk_util.notebook_root(path) == nil then
    return false
  end

  return true
end


---@type LazySpec
return {
  "zk-org/zk-nvim",
  name = "zk",
  ft = { "markdown" },
  lazy = true,
  cmd = {
    "ZkIndex",
    "ZkNew",
    "ZkNewFromTitleSelection",
    "ZkNewFromContentSelection",
    "ZkNotes",
    "ZkBuffers",
    "ZkBacklinks",
    "ZkLinks",
    "ZkInsertLink",
    "ZkInsertLinkAtSelection",
    "ZkMatch",
    "ZkTags",
    "ZkCd",
  },
  opts = {
    -- Can be "telescope", "fzf", "fzf_lua", "minipick", "snacks_picker",
    -- or select" (`vim.ui.select`).
    picker = "snacks_picker",

    lsp = {
      -- `config` is passed to `vim.lsp.start(config)`
      config = {
        name = "zk",
        cmd = { "zk", "lsp" },
        filetypes = { "markdown" },
        -- on_attach = ...
        -- etc, see `:h vim.lsp.start()`
      },

      -- automatically attach buffers in a zk notebook that match the given filetypes
      auto_attach = {
        enabled = true,
      },
    },
  },
  dependencies = {
    {
      "AstroNvim/astroui",
      opts = {
        icons = {
          Zettelkasten = "󰠮",
          ZettelkastenPrivate = "⚿",
        }
      }
    },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        local prefix = "<Leader>Z"
        local astroui = require "astroui"
        if not opts.autocmds then opts.autocmds = {} end
        local au = opts.autocmds

        local function get_current_visual_text()
          local mode = vim.fn.mode()

          if mode ~= "v" and mode ~= "V" then
            return nil, mode
          end

          local lines = vim.fn.getregion(
            vim.fn.getpos("v"),
            vim.fn.getpos("."),
            {
              type = mode,
              exclusive = false,
            }
          )

          return table.concat(lines, "\n"), mode
        end

        local function zk_new(has_selection, is_private)
          local options = {}

          if has_selection then
            local selected_text, visual_mode = get_current_visual_text()
            if selected_text == "" then
              return nil
            end

            if visual_mode == "v" then
              options.title = selected_text
              options.content = "$1"
            elseif visual_mode == "V" then
              options.title = "$1"
              options.content = selected_text
            else
              return nil
            end
          else
            options.title = "$1"
            options.content = "$0"
          end

          if is_private then
            options.dir = "private"
          end

          return require("zk").new(options)
        end

        local general_maps = {
          n = {
            [prefix] = {
              desc = astroui.get_icon("Zettelkasten", 1, true) .. "Zettelkasten",
            },
            [prefix .. "p"] = {
              desc = astroui.get_icon("ZettelkastenPrivate", 1, true) .. "Private",
            },
            [prefix .. "n"] = {
              function() zk_new(false, false) end,
              --
              -- function()
              --   local options = {}
              --   options.title = "$1"
              --   return require("zk").new(options)
              --   -- local title = vim.fn.input('Title: ')
              --   -- if title ~= "" then
              --   --   return require("zk.commands").get("ZkNew")({ title = title })
              --   -- else
              --   --   return nil
              --   -- end
              -- end,
              desc = "New note",
            },
            [prefix .. "pn"] = {
              function() zk_new(false, true) end,
              desc = "New private note",
            },
            [prefix .. "f"] = {
              function()
                require("zk.commands").get("ZkNotes")()
              end,
              desc = "Find notes",
            },
            [prefix .. "t"] = {
              function()
                require("zk.commands").get("ZkTags")()
              end,
              desc = "Find tags",
            },
          },
          x = {
            [prefix] = {
              desc = astroui.get_icon("Zettelkasten", 1, true) .. "Zettelkasten",
            },
            [prefix .. "p"] = {
              desc = astroui.get_icon("ZettelkastenPrivate", 1, true) .. "Private",
            },
            [prefix .. "n"] = {
              function() zk_new(true, false) end,
              desc = "New note",
            },
            [prefix .. "pn"] = {
              function() zk_new(true, true) end,
              desc = "New private note",
            },
          },
        }

        opts.mappings = vim.tbl_deep_extend("force", opts.mappings or {}, general_maps)

        au.zk_note_mappings = {
          {
            event = "FileType",
            pattern = "markdown",
            desc = "Set zk mappings for note buffers",
            callback = function(args)

              if not is_zk_note(args.buf) then
                return
              end

              local zk_maps = {
                n = {
                  ["<CR>"] = {
                    function()
                      vim.lsp.buf.definition()
                    end,
                    desc = "Open note link",
                  },
                  ["K"] = {
                    function()
                      vim.lsp.buf.hover()
                    end,
                    desc = "Preview note link",
                  },
                  [prefix .. "b"] = {
                    "<Cmd>ZkBacklinks<CR>",
                    desc = "Show backlinks",
                  },
                  [prefix .. "l"] = {
                    "<Cmd>ZkLinks<CR>",
                    desc = "Show links",
                  },
                  [prefix .. "i"] = {
                    "<Cmd>ZkInsertLink<CR>",
                    desc = "Insert note link",
                  },
                },
                x = {
                  [prefix .. "i"] = {
                    ":'<,'>ZkInsertLinkAtSelection<CR>",
                    desc = "Insert note link at selection",
                  },
                  [prefix .. "a"] = {
                    ":'<,'>lua vim.lsp.buf.range_code_action()<CR>",
                    desc = "Show code actions",
                  },
                },
              }

              require("astrocore").set_mappings(zk_maps, { buffer = args.buf })
            end,
          },
        }

        au.zk_template_expand = {
          {
            event = "BufWinEnter",
            pattern = "*.md",
            desc = "Expand template snippets inside zk notebook buffers",
            callback = function(args)
              -- Ensure this is a valid zk note before proceeding
              if not is_zk_note(args.buf) then
                return
              end

              -- Guard against multi-execution if FileType triggers again
              if vim.b[args.buf].zk_template_processed then
                return
              end
              vim.b[args.buf].zk_template_processed = true

              local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
              local template_line_idx = nil
              local in_front_matter = false

              -- Parse YAML front matter boundaries
              for i, line in ipairs(lines) do
                if line:match("^%-%-%-%s*$") then
                  if not in_front_matter then
                    in_front_matter = true
                  else
                    break -- End of front matter
                  end
                elseif in_front_matter then
                  if line:match("^template:%s*true%s*$") then
                    template_line_idx = i
                  end
                end
              end

              -- If the template token is found, recreate the buffer as a live snippet
              if template_line_idx then
                table.remove(lines, template_line_idx)
                local content = table.concat(lines, "\n")

                -- Clear and expand
                vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, {})
                local mini_snippets = require("mini.snippets")
                local insert = mini_snippets.config.expand.insert or mini_snippets.default_insert
                insert({ body = content })
              end
            end,
          },
        }

        au.zk_disable_other_lsp = {
          {
            event = "LspAttach",
            pattern = "*.md",
            desc = "Disable any non-zk LSP inside zk notebook buffers",
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              -- If the client is missing or it is the "zk" server itself, do nothing
              if not client or client.name == "zk" then
                return
              end

              if not is_zk_note(args.buf) then
                return
              end

              -- Defer detachment to ensure Neovim finishes registering the client first
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(args.buf) then
                  ---@diagnostic disable-next-line: undefined-field
                  if client.detach_buffer then
                    ---@diagnostic disable-next-line: undefined-field
                    client:detach_buffer(args.buf)
                  else
                    vim.lsp.buf_detach_client(args.buf, client.id)
                  end
                end
              end)
            end,
          },
        }
      end,
    },
    {
      "riodelphino/zk-bufferline.nvim",
      opts = {},
      dependencies = {
        "akinsho/bufferline.nvim",
        {
          "riodelphino/zk-buf-cache.nvim",
          opts = {},
        },
      },
    },
    {
      "riodelphino/zk-auto-update.nvim",
      opts = {
        enabled = true,
        triggers = {
          on_save = {
            enabled = true,
            event = "BufWritePre",
            rules = {
              ['Update datetime (`modified` as 2025-01-01 00:00:00)'] = {
                enabled = true,
                scope = 'line',
                pattern = "^(modified *: *)(%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d:%d%d.+)$", -- line matching pattern
                ---@param captures table
                ---@param _ string
                ---@return string
                format = function(captures, _) -- formatter for captured items
                  captures[2] = os.date("%Y-%m-%dT%H:%M:%S%z")
                  return table.concat(captures)
                end,
                in_yaml = true, -- true: only matches in YAML frontmatter / false: only matches in content
                notebook_paths = {}, -- valie notebook_paths (default: allows all notebook_paths)
                dirs = {}, -- valid directories (default: allows all dirctories)
              },
            },
          },
        },
      },
    },
    {
      "echasnovski/mini.snippets",
      opts = {},
    },
  },
}
