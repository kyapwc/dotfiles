local M = {}
local api = vim.api

local servers = {
  gopls = {},
  html = {},
  jsonls = {},
  pyright = {},
  sumneko_lua = {
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          }
        }
      },
    },
  },
  tsserver = {
  },
  vimls = {},
  eslint = {},
  bashls = {},
  marksman = {},
  svelte = {},
  -- tailwindcss = {},
  cssls = {},
  vuels = {},
}

local lsp_signature = require "lsp_signature"
lsp_signature.setup {
  bind = true,
  handler_opts = {
    border = "rounded",
  },
}

local function on_attach(client, bufNo)
  api.nvim_buf_set_option(bufNo, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

  local signs = {
    { name = 'DiagnosticSignError', text = 'E' },
    { name = 'DiagnosticSignWarn', text = 'W' },
    { name = 'DiagnosticSignHint', text = 'H' },
    { name = 'DiagnosticSignInfo', text = 'I' },
  }

  local config = {
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      update_in_insert = false,
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(config)

  require('yap.config.lsp.keymaps').setup(client, bufNo)
end

local options = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 200,
    exit_timeout = 0,
  },
}

function M.setup()
  require('yap.config.lsp.installer').setup(servers, options)
end

return M
