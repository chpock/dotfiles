return {
  "akinsho/bufferline.nvim",
  opts = {
    options = {
      numbers = "ordinal",
      show_buffer_close_icons = false,
      show_close_icon = false,
    },
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<M-1>"] = {
              function()
                require("bufferline").go_to(1, true)
              end,
              desc = "Switch to buffer #1"
            },
            ["<M-2>"] = {
              function()
                require("bufferline").go_to(2, true)
              end,
              desc = "Switch to buffer #2"
            },
            ["<M-3>"] = {
              function()
                require("bufferline").go_to(3, true)
              end,
              desc = "Switch to buffer #3"
            },
            ["<M-4>"] = {
              function()
                require("bufferline").go_to(4, true)
              end,
              desc = "Switch to buffer #4"
            },
            ["<M-5>"] = {
              function()
                require("bufferline").go_to(5, true)
              end,
              desc = "Switch to buffer #5"
            },
            ["<M-6>"] = {
              function()
                require("bufferline").go_to(6, true)
              end,
              desc = "Switch to buffer #6"
            },
            ["<M-7>"] = {
              function()
                require("bufferline").go_to(7, true)
              end,
              desc = "Switch to buffer #7"
            },
            ["<M-8>"] = {
              function()
                require("bufferline").go_to(8, true)
              end,
              desc = "Switch to buffer #8"
            },
            ["<M-9>"] = {
              function()
                require("bufferline").go_to(9, true)
              end,
              desc = "Switch to buffer #9"
            },
            ["<M-0>"] = {
              function()
                require("bufferline").go_to(10, true)
              end,
              desc = "Switch to buffer #10"
            },
          },
          i = {
            ["<M-1>"] = {
              function()
                require("bufferline").go_to(1, true)
              end,
              desc = "Switch to buffer #1"
            },
            ["<M-2>"] = {
              function()
                require("bufferline").go_to(2, true)
              end,
              desc = "Switch to buffer #2"
            },
            ["<M-3>"] = {
              function()
                require("bufferline").go_to(3, true)
              end,
              desc = "Switch to buffer #3"
            },
            ["<M-4>"] = {
              function()
                require("bufferline").go_to(4, true)
              end,
              desc = "Switch to buffer #4"
            },
            ["<M-5>"] = {
              function()
                require("bufferline").go_to(5, true)
              end,
              desc = "Switch to buffer #5"
            },
            ["<M-6>"] = {
              function()
                require("bufferline").go_to(6, true)
              end,
              desc = "Switch to buffer #6"
            },
            ["<M-7>"] = {
              function()
                require("bufferline").go_to(7, true)
              end,
              desc = "Switch to buffer #7"
            },
            ["<M-8>"] = {
              function()
                require("bufferline").go_to(8, true)
              end,
              desc = "Switch to buffer #8"
            },
            ["<M-9>"] = {
              function()
                require("bufferline").go_to(9, true)
              end,
              desc = "Switch to buffer #9"
            },
            ["<M-0>"] = {
              function()
                require("bufferline").go_to(10, true)
              end,
              desc = "Switch to buffer #10"
            },
          },
        }
      }
    }
  }
}
