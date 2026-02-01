return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = false,
      },
      follow_current_file = {
        -- do not jump to current file when active buffer changed
        enabled = false,
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          -- auto close when a file is selected
          _G.neotree_last_path = file_path
          require("neo-tree.command").execute({ action = "close" })
          -- close possible empty buffers
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            -- Check if buffer is valid, listed, and has no name (empty)
            if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == "" then
              -- Check if it is not modified and is a normal buffer
              local is_modified = vim.api.nvim_get_option_value("modified", { buf = buf })
              local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
              if not is_modified and buftype == "" then
                -- Force delete the empty buffer
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end
        end
      },
    },
  },
}
