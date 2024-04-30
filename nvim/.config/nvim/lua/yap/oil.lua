local oil = require('oil')

oil.setup({
  columns = {
    { 'size', highlight = 'Special' },
    'icon',
  },
  win_options = {
    signcolumn = 'yes',
  },
  keymaps = {
    ['<Tab>'] = 'actions.select_vsplit',
    ['<C-h>'] = '',
    ['<C-s>'] = '',
  },
  float = {
    padding = 10,
    border = 'rounded',
  },
})

-- vim.keymap.set('n', '-', oil.open, { desc = 'Open Parent Directory' })
vim.keymap.set('n', '|', ':Oil --float<CR>', { desc = 'Open Float Directory' })
vim.keymap.set('n', '-', oil.open, { desc = 'Open Float Directory' })
