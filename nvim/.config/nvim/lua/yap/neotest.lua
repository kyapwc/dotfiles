local neotest = require('neotest')
local neotest_jest = require('neotest-jest')

neotest.setup({
  adapters = {
    neotest_jest({
      cwd = function(path)
        return vim.fn.getcwd()
      end,
      discovery = { enabled = false },
    })
  },
  quickfix = {
    enabled = true,
    open = true,
  },
  running = { concurrent = true },
})

local function run_and_show_output()
  neotest.run.run()
end

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { "*.test.ts", "*.test.js" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ns', ':lua require("neotest").summary.toggle()<CR>',
      { desc = "Tests summary" })
    vim.keymap.set('n', '<leader>nr', run_and_show_output, { buffer = 0, desc = "Run tests" })
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>np', ':lua require("neotest").output_panel.toggle()<CR>',
      { desc = "Open output panel" })
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>no', ':lua require("neotest").output.open({ enter = true })<CR>',
      { desc = "Show output" })
  end,
})
