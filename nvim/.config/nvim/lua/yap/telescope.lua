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
  extensions = {
    recent_files = {
      only_cwd = true,
    },
  },
})

vim.api.nvim_set_keymap('n', '<leader>u', [[<cmd>lua require('telescope').extensions.recent_files.pick()<CR>]],
  { noremap = true, silent = true })
