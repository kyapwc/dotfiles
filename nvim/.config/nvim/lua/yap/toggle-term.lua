local toggleterm = require("toggleterm")

toggleterm.setup({
  shade_terminals = false,
  highlights = {
    StatusLine = { guifg = "#ffffff", guibg = "#0E1018" },
    StatusLineNC = { guifg = "#ffffff", guibg = "#0E1018" }
  }
})

vim.keymap.set('n', '<leader><leader>', ':ToggleTerm size=15<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':ToggleTerm size=70 direction=vertical<CR>', { noremap = true, silent = true })

vim.opt.laststatus = 3
