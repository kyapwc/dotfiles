local M = {}
local api = vim.api
local neodev = require('neodev')
local mason = require('mason')

mason.setup({
  ui = { border = 'rounded' }
})

neodev.setup({})

local lsp_signature = require "lsp_signature"
lsp_signature.setup {
  bind = true,
  handler_opts = {
    border = "rounded",
  },
  floating_window = true,
  doc_lines = 50,
  wrap = true,
  fix_pos = true,
  -- always_trigger = true,
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

  require('lsp_signature').on_attach({
    bind = true,
    handler_opts = {
      border = "rounded",
    },
    floating_window = true,
    doc_lines = 50,
    wrap = true,
    fix_pos = true,
    -- always_trigger = true,
    toggle_key = '<C-x>',
  }, bufNo)
  require('yap.config.lsp.keymaps').setup(client, bufNo)
end

local servers = {
  gopls = {},
  html = {},
  jsonls = {},
  pyright = {},
  lua_ls = {
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          -- P is custom global function to print table
          globals = { "vim", "P" },
        },
        -- workspace = {
        --   library = {
        --     [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        --     [vim.fn.stdpath("config") .. "/lua"] = true,
        --   }
        -- },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
  tsserver = {
    on_attach = on_attach,
    init_options = {
      maxTsServerMemory = 8192,
    },
  },
  vimls = {},
  eslint = {
    on_attach = on_attach,
  },
  bashls = {},
  svelte = {},
  -- tailwindcss = {},
  cssls = {},
  vuels = {},
  rust_analyzer = {},
}


-- local options = {
--   on_attach = on_attach,
--   flags = {
--     debounce_text_changes = 200,
--     exit_timeout = 0,
--   },
-- }
--
function M.setup()
  require('yap.config.lsp.installer').setup(servers)
end

return M
