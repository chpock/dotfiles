---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local function yaml_ft(_, bufnr)
      -- Read first 20 lines
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 20, false)
      local has = {
        cfn = false,
        sam = false,
        k8s = {
          apiVersion = false,
          kind = false,
        }
      }
      for _, line in ipairs(lines) do
        if line:match '^AWSTemplateFormatVersion' or line:match '^ *Resources:' then
          has.cfn = true
        elseif line:match '^Transform: .*::Serverless.*' then
          has.sam = true
        elseif line:match '^apiVersion:' then
          has.k8s.apiVersion = true
        elseif line:match '^kind:' then
          has.k8s.kind = true
        end
      end
      if has.sam then
        return "yaml.sam"
      elseif has.cfn then
        return "yaml.cfn"
      elseif has.k8s.apiVersion and has.k8s.kind then
        return "yaml.k8s"
      end
      -- return yaml if nothing else
      return "yaml"
    end
    local function yaml_lsp(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client or client.name ~= 'yamlls' then
        return
      end
      local filetype = vim.bo[event.buf].filetype
      local is_cfn = filetype == 'yaml.cfn'
      local is_sam = filetype == 'yaml.sam'
      if not is_cfn and not is_sam then
        return
      end
      local yamlls_config = client.config.settings.yaml
      local filepath = vim.api.nvim_buf_get_name(event.buf)

      if is_sam then
        ---@diagnostic disable-next-line: inject-field
        yamlls_config.schemas = {
          ['https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json'] = {
            filepath,
          },
        }
      else
        -- Do not use any schema for CFN. The below schema is the only available and it
        -- gives a lot of false positive alarms. It is better to disable schema for CFN
        -- templates at all.
        --
        -- ---@diagnostic disable-next-line: inject-field
        -- yamlls_config.schemas = {
        --   ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] = {
        --     filepath,
        --   },
        -- }
        ---@diagnostic disable-next-line: inject-field
        yamlls_config.schemas = {}
      end

      ---@diagnostic disable-next-line: inject-field
      yamlls_config.customTags = {
        '!And scalar',
        '!And mapping',
        '!And sequence',
        '!If scalar',
        '!If mapping',
        '!If sequence',
        '!Not scalar',
        '!Not mapping',
        '!Not sequence',
        '!Equals scalar',
        '!Equals mapping',
        '!Equals sequence',
        '!Or scalar',
        '!Or mapping',
        '!Or sequence',
        '!FindInMap scalar',
        '!FindInMap mappping',
        '!FindInMap sequence',
        '!Base64 scalar',
        '!Base64 mapping',
        '!Base64 sequence',
        '!Cidr scalar',
        '!Cidr mapping',
        '!Cidr sequence',
        '!Ref scalar',
        '!Ref mapping',
        '!Ref sequence',
        '!Sub scalar',
        '!Sub mapping',
        '!Sub sequence',
        '!GetAtt scalar',
        '!GetAtt mapping',
        '!GetAtt sequence',
        '!GetAZs scalar',
        '!GetAZs mapping',
        '!GetAZs sequence',
        '!ImportValue scalar',
        '!ImportValue mapping',
        '!ImportValue sequence',
        '!Select scalar',
        '!Select mapping',
        '!Select sequence',
        '!Split scalar',
        '!Split mapping',
        '!Split sequence',
        '!Join scalar',
        '!Join mapping',
        '!Join sequence',
        '!Condition scalar',
        '!Condition mapping',
        '!Condition sequence',
      }

      ---@diagnostic disable-next-line: param-type-mismatch
      client.notify('workspace/didChangeConfiguration', { settings = yamlls_config })
    end
    opts = require("astrocore").extend_tbl(opts, {
      -- git_worktrees = {
      --   { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "/.local/share/yadm/repo.git" },
      -- },
      -- Configure core features of AstroNvim
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
        autopairs = false, -- disable autopairs
        cmp = true, -- enable completion at start
        diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
        highlighturl = true, -- highlight URLs at start
        notifications = true, -- enable notifications at start
      },
      -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
      diagnostics = {
        virtual_text = true,
        underline = true,
      },
      -- -- passed to `vim.filetype.add`
      filetypes = {
        -- see `:h vim.filetype.add` for usage
        extension = {
          yaml = yaml_ft,
          yml = yaml_ft,
        },
      --   filename = {
      --     [".foorc"] = "fooscript",
      --   },
      --   pattern = {
      --     [".*/etc/foo/.*"] = "fooscript",
      --   },
      },
      -- vim options can be configured here
      options = {
        opt = { -- vim.opt.<key>
          relativenumber = false, -- sets vim.opt.relativenumber
          number = true, -- sets vim.opt.number
          spell = false, -- sets vim.opt.spell
          signcolumn = "yes", -- sets vim.opt.signcolumn to yes
          wrap = false, -- sets vim.opt.wrap
          guifont = "monospace,Noto_Color_Emoji:h12",
          -- don't use system clipboard by default for copy/depete/paste
          clipboard = {},
          -- don't jump to the first char when paging
          startofline = false,
          -- Don't set hlsearch option here. Its state will come from specific session.
          -- hlsearch = true, -- highlight search terms
          incsearch = true, -- show search matches as you type
          ignorecase = true, -- ignore case when searching
          smartcase = true, -- ignore case if search pattern is all lowercase, case-sensitive otherwise
        },
        g = { -- vim.g.<key>
          -- configure global vim variables (vim.g)
          -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
          -- This can be found in the `lua/lazy_setup.lua` file
        },
      },
      -- Don't turn off hlsearch during cursor movement
      on_keys = {
        auto_hlsearch = false,
      },
      -- Mappings can be configured through AstroCore as well.
      -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
      mappings = {
        -- first key is the mode
        v = {
          ["<C-/>"] = { "gc", remap = true, desc = "Toggle comment" },
          -- Ctrl-C in visual mode - copy to system clipboard
          ["<C-C>"] = { '"+y', desc = "Copy selection to system clipboard" },
        },
        x = {
          ["<C-/>"] = { "gc", remap = true, desc = "Toggle comment" },
          -- Ctrl-C in visual mode - copy to system clipboard
          ["<C-C>"] = { '"+y', desc = "Copy selection to system clipboard" },
        },
        i = {
          ["<C-L>"] = { "<Cmd>nohlsearch<CR>", desc = "Turn off search highlight" },
          ["<C-/>"] = { "<C-O>gcc", remap = true, desc = "Toggle comment line" },
          -- Ctrl-P in insert mote - paste from system clipboard
          -- ["<C-P>"] = { '<C-r>+', desc = "Paste from system clipboard" },
          ["<PageUp>"] = { "<C-O><C-U><C-O><C-U><C-O>zz", desc = "Scroll: Page up" },
          ["<PageDown>"] = { "<C-O><C-D><C-O><C-D><C-O>zz", desc = "Scroll: Page down" },
          ["<C-E>"] = {
            function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd.wincmd "p"
              else
                vim.cmd.stopinsert()
                vim.cmd.Neotree "focus"
              end
            end, desc = "Toggle Explorer focus",
          },
          -- ["<C-Q>"] = { "<Cmd>qa!<CR>", desc = "Force quit" },
        },
        n = {
          ["<C-L>"] = { "<Cmd>nohlsearch<CR>", desc = "Turn off search highlight" },
          ["<C-/>"] = { "gcc", remap = true, desc = "Toggle comment line" },
          ["<PageUp>"] = { "<C-U><C-U>zz", desc = "Scroll: Page up" },
          ["<PageDown>"] = { "<C-D><C-D>zz", desc = "Scroll: Page down" },
          ["<C-E>"] = {
            function()
              if vim.bo.filetype == "neo-tree" then
                vim.cmd.wincmd "p"
              else
                vim.cmd.Neotree "focus"
              end
            end,
            desc = "Toggle Explorer focus",
          },
          -- ["<C-Q>"] = { "<Cmd>qa!<CR>", desc = "Force quit" },
          -- navigate buffer tabs
          ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

          -- Open Dashboard Automatically When No More Buffers
          ["<Leader>c"] = {
            function()
              local bufs = vim.fn.getbufinfo({ buflisted = 1 })
              require("astrocore.buffer").close(0)
              if not bufs[2] then
                require("snacks").dashboard()
              end
            end,
            desc = "Close buffer",
          },

          -- tables with just a `desc` key will be registered with which-key if it's installed
          -- this is useful for naming menus
          -- ["<Leader>b"] = { desc = "Buffers" },

          -- setting a mapping to false will disable it
          -- ["<C-S>"] = false,
        },
      },
      -- Disable session management (resession plugin) from Astronvim.
      -- We use neovim-project plugin with session manager neovim-session-manager.
      sessions = {
        autosave = { last = false, cwd = false },
      },
      -- sessions = {
      --   -- Configure auto saving
      --   autosave = {
      --     last = false, -- auto save last session
      --     cwd = true, -- auto save session for each working directory
      --   },
      --   -- Patterns to ignore when saving sessions
      --   ignore = {
      --     dirs = {}, -- working directories to ignore sessions in
      --     filetypes = { "gitcommit", "gitrebase" }, -- filetypes to ignore sessions
      --     buftypes = {}, -- buffer types to ignore sessions
      --   },
      -- },
      autocmds = {
        set_yaml_scheme = {
          {
            event = 'LspAttach',
            pattern = { '*.yaml', '*.yml' },
            desc = 'Set custom YAML schema for LSP',
            callback = yaml_lsp,
          },
        },
        -- Session managers like resession and neovim-session-manager save session
        -- on VimLeavePre event. However, this doesn't work always and somethimes
        -- these events are not fired. We will save here neovim-session-manager session to ensure that our session is correctly saved.
        save_session = {
          {
            event = "QuitPre",
            desc = "Save session before quiting",
            callback = function()
              require("session_manager").save_current_session()
            end,
          },
        },
        -- Show file tree after opening a project/session
        show_file_tree = {
          {
            event = "User",
            pattern = "SessionLoadPost",
            desc = "Show file tree on session load",
            callback = function()
              require("neo-tree.command").execute({ action = "show" })
            end,
          }
        }
      --   restore_session = {
      --     {
      --       event = "VimEnter",
      --       desc = "Restore previous directory session if neovim opened with no arguments",
      --       nested = true, -- trigger other autocommands as buffers open
      --       callback = function()
      --         -- Only load the session if nvim was started with no args
      --         if vim.fn.argc(-1) == 0 then
      --           -- try to load a directory session using the current working directory
      --           require("resession").load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
      --         end
      --       end,
      --     },
      --   },
        -- Due to unknown reason, resession plugin doesn't save new opened buffers for current session
        -- during automatic saving on VimLeavePre event. It saves a session correctly only when session
        -- is saved manually. To avoid this bug, we will save session after each buffer reading or
        -- creation.
        -- save_session_buf_read_post = {
        --   {
        --     event = "BufReadPost",
        --     desc = "Save after new buffer read",
        --     callback = function()
        --       local buf_utils = require "astrocore.buffer"
        --       local autosave = require("astrocore").config.sessions.autosave
        --       if autosave and buf_utils.is_valid_session() then
        --         local save = require("resession").save
        --         save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
        --       end
        --     end,
        --   },
        -- },
        -- save_session_buf_new_file = {
        --   {
        --     event = "BufNewFile",
        --     desc = "Save after new buffer created",
        --     callback = function()
        --       local buf_utils = require "astrocore.buffer"
        --       local autosave = require("astrocore").config.sessions.autosave
        --       if autosave and buf_utils.is_valid_session() then
        --         local save = require("resession").save
        --         save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
        --       end
        --     end,
        --   },
        -- },
      },
    })
    return opts
  end,
}
