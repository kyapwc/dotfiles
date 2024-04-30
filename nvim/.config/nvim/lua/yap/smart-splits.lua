local smart_splits = require('smart-splits')

smart_splits.setup({
  default_amount = 'stop',
  disable_multiplexer_nav_when_zoomed = false,
})

vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)
