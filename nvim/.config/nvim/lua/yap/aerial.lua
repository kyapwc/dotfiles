local aerial = require('aerial')

aerial.setup({
  autojump = true,
  manage_folds = true,
})

vim.keymap.set('n', '<C-\\>', '<cmd>AerialToggle!<CR>')
