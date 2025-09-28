return {

  "chpock/nvim-jenkinsfile-linter",
  -- dir = "/w/projects/nvim-jenkinsfile-linter",
  -- name = "nvim-jenkinsfile-linter",
  -- dev = true,

  ft = { "groovy" },
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  specs = {
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        mappings = {
          n = {
            ["<Leader>lJ"] = {
              function()
                if vim.env.JENKINS_URL == nil or vim.env.JENKINS_URL == "" then
                  local jenkins_url = ""
                  local config_file = vim.fn.stdpath("data") .. "/nvim-jenkinsfile-linter-config.json"
                  local uv = vim.uv
                  local fd = uv.fs_open(config_file, "r", 438)
                  if fd ~= nil then
                    local stat = uv.fs_fstat(fd)
                    if stat and stat.size then
                      local data = uv.fs_read(fd, stat.size, 0)
                      uv.fs_close(fd)
                      if data and data ~= "" then
                        local ok, decoded = pcall(vim.fn.json_decode, data)
                        if ok and decoded.JENKINS_URL then
                          jenkins_url = decoded.JENKINS_URL
                        end
                      end
                    end
                  end
                  local value = vim.fn.input("Enter value for JENKINS_URL: ", jenkins_url)
                  -- If user typed something, set the environment variable
                  if value ~= nil and value ~= "" then
                    vim.env.JENKINS_URL = value
                    local encoded = vim.fn.json_encode({ JENKINS_URL = value })
                    fd = uv.fs_open(config_file, "w", 438)
                    if fd then
                      uv.fs_write(fd, encoded, -1)
                      uv.fs_close(fd)
                    end
                  else
                    vim.notify("JENKINS_URL was not set (empty input)", vim.log.levels.WARN)
                    return
                  end
                end
                require("jenkinsfile_linter").validate()
              end,
              desc = "Run Jenkins linter"
            },
          },
        },
      },
    },
  },
}
