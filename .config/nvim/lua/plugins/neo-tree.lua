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
  },
}
