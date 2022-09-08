vim.cmd[[
  let g:minimap_block_filetypes = ['fugitive', 'fzf']
]]

vim.keymap.set('n', '<space>ma', ':MinimapToggle<CR>')
