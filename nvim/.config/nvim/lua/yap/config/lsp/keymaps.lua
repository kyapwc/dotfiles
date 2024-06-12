local M = {}
local keymap = vim.keymap

local function keymappings(client, bufNo)
  local opts = { noremap = true, silent = true }

  -- Key mappings
  keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
  keymap.set('n', '<space>E', vim.diagnostic.goto_prev, opts)
  keymap.set('n', '<space>e', vim.diagnostic.goto_next, opts)
  keymap.set('n', '<space>l', vim.diagnostic.setloclist, opts)

  local bufopts = { noremap = true, silent = true, buffer = bufNo }
  local renameOpts = vim.tbl_extend('force', bufopts, { desc = 'Rename word under cursor?' } )
  keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  keymap.set('n', 'gD', vim.lsp.buf.implementation, bufopts)
  keymap.set('n', '<c-m>', vim.lsp.buf.signature_help, bufopts)
  keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  keymap.set('n', '<leader>rn', vim.lsp.buf.rename, renameOpts)
  keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
  -- keymap.set('n', '<space>a', function()
  --   require('fzf-lua').lsp_code_actions({
  --     winopts = {
  --       relative = 'cursor',
  --       width = 0.6,
  --       height = 0.6,
  --       row = 1,
  --       preview = { vertical = 'up:70%' },
  --     },
  --   })
  -- end, bufopts)
  keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  keymap.set('n', '<space>ff', vim.lsp.buf.format, bufopts)
  keymap.set('n', '<C-]>', vim.lsp.buf.definition, bufopts)
  -- keymap.set('n', '<space>h', require('yap/config/lsp/hover').hover, bufopts)
end

function M.setup(client, bufNo)
  keymappings(client, bufNo)
end

return M
