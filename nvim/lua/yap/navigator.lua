local navigator = require('Navigator')

navigator.setup()

vim.keymap.set({'n', 't'}, '<C-h>', navigator.left)
vim.keymap.set({'n', 't'}, '<C-j>', navigator.down)
vim.keymap.set({'n', 't'}, '<C-k>', navigator.up)
vim.keymap.set({'n', 't'}, '<C-l>', navigator.right)
