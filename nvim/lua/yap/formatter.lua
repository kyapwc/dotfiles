local formatter = require('formatter')

formatter.setup({
  logging= true,
  log_level = vim.log.levels.WARN,
  filetype = {
    typescript = {
      function()
        return {
          exe = "prettierd",
          args = {vim.api.nvim_buf_get_name(0)},
          stdin = true
        }
      end
    },
    javascript = {
      function()
        return {
          exe = "prettierd",
          args = {vim.api.nvim_buf_get_name(0)},
          stdin = true
        }
      end
    },
  },
})
