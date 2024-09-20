local telescope = require('telescope')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = require('telescope.actions').close,
        ['<C-k>'] = require('telescope.actions').move_selection_previous,
        ['<C-j>'] = require('telescope.actions').move_selection_next,
        ['<C-q>'] = require('telescope.builtin').quickfix,
      }
    },
  },
})

telescope.load_extension('gh')
