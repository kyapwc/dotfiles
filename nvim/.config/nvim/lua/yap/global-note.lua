local globalNote = require('global-note')

globalNote.setup()

vim.keymap.set('n', '<LEADER>gn', globalNote.toggle_note, { desc = 'Toggle Global Note' })
