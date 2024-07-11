local aerial = require('aerial')

aerial.setup({
  autojump = true,
})

vim.keymap.set('n', '<C-\\>', '<cmd>AerialToggle!<CR>')
