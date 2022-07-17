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
  keymap.set('n', 'gd', vim.lsp.buf.declaration, bufopts)
  keymap.set('n', 'gD', vim.lsp.buf.definition, bufopts)
  keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  keymap.set('n', '<space>i', vim.lsp.buf.signature_help, bufopts)
  -- keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  -- keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

function M.setup(client, bufNo)
  keymappings(client, bufNo)
end

return M
