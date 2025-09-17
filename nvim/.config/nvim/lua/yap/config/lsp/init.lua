local M = {}
local api = vim.api
-- local neodev = require('neodev')
local mason = require('mason')
local navic = require('nvim-navic')

mason.setup({
  ui = { border = 'rounded' }
})

-- neodev.setup({})

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
  max_width = 200,
  -- always_trigger = true,
}

local function validate_bufnr(bufnr)
  vim.validate {
    bufnr = { bufnr, 'n' },
  }
  return bufnr == 0 and api.nvim_get_current_buf() or bufnr
end

local function get_active_client_by_name(bufnr, servername)
  for _, client in pairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
    if client.name == servername then
      return client
    end
  end
end

local function fix_all(opts)
  opts = opts or {}
  local bufNr = vim.api.nvim_get_current_buf()

  local eslint_lsp_client = get_active_client_by_name(bufNr, 'eslint')
  if eslint_lsp_client == nil then
    return
  end

  local request
  if opts.sync then
    request = function(bufnr, method, params)
      eslint_lsp_client.request_sync(method, params, nil, bufnr)
    end
  else
    request = function(bufnr, method, params)
      eslint_lsp_client.request(method, params, nil, bufnr)
    end
  end

  local bufnr = validate_bufnr(bufNr or 0)
  request(0, 'workspace/executeCommand', {
    command = 'eslint.applyAllFixes',
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  })
end

local signs = {
  { name = 'DiagnosticSignError', text = 'E' },
  { name = 'DiagnosticSignWarn',  text = 'W' },
  { name = 'DiagnosticSignHint',  text = 'H' },
  { name = 'DiagnosticSignInfo',  text = 'I' },
}

local vimConfig = {
  virtual_text = false, -- annoying virtual texts
  -- virtual_text = {
  --   severity = { min = vim.diagnostic.severity.WARN },
  -- },
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
    -- border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
    border = {
      { '┌', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '┐', 'FloatBorder' },
      { '│', 'FloatBorder' },
      { '┘', 'FloatBorder' },
      { '─', 'FloatBorder' },
      { '└', 'FloatBorder' },
      { '│', 'FloatBorder' },
    }
  },
}


vim.diagnostic.config(vimConfig)

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
  callback = function()
    fix_all({ sync = true })
  end,
})

local function on_attach_eslint(client, bufNo)
  client.server_capabilities.document_formatting = true;

  api.nvim_buf_set_option(bufNo, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

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

vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

local function on_attach(client, bufNo)
  client.server_capabilities.document_formatting = true;

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufNo)
  end

  api.nvim_buf_set_option(bufNo, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

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
  gopls = {
    on_attach = on_attach,
  },
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
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }
      },
    },
  },
  vimls = {},
  eslint = {
    on_attach = on_attach_eslint,
  },
  bashls = { on_attach = on_attach },
  svelte = {},
  tailwindcss = {
    root_dir = function(fname)
      local root_pattern = require("lspconfig").util.root_pattern(
        "tailwind.config.cjs",
        "tailwind.config.js",
        "tailwind.config.ts",
        "postcss.config.js"
      )
      return root_pattern(fname)
    end,
  },
  cssls = {},
  vuels = {},
  rust_analyzer = {},
  sqlls = {},
  clangd = {},
  csharp_ls = {}
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
