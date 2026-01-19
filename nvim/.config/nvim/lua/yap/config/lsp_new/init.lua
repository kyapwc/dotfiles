local navic = require('nvim-navic')
local mason = require('mason')

local api = vim.api

local M = {}

mason.setup({
  ui = { border = 'rounded' }
})

local signatureConfig = {
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
}

-- local function on_attach_eslint(client, bufNo)
--   client.server_capabilities.document_formatting = true;
--
--   api.nvim_buf_set_option(bufNo, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--   api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
--   -- require('yap.config.lsp.keymaps').setup(client, bufNo)
-- end

local function on_attach(client, bufNo)
  -- client.server_capabilities.document_formatting = true;

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufNo)
  end

  api.nvim_buf_set_option(bufNo, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  vim.lsp.inlay_hint.enable(false, { bufnr = bufNo })
  -- require('yap.config.lsp.keymaps').setup(client, bufNo)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    local reference_opts = { buffer = ev.buf, desc = '[LSP] References' }
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>E', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<space>e', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>rr', vim.lsp.buf.references, reference_opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    require('lsp_signature').on_attach(signatureConfig, ev.buf)
  end,
})

local servers = {
  -- gopls = {
  --   on_attach = on_attach,
  -- },
  html = {},
  jsonls = {
    init_options = {
      provideFormatter = false,
    },
  },
  pyright = {},
  lua_ls = {
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "P" },
        },
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },
  ts_ls = {
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
  eslint = { on_attach = on_attach },
  bashls = { on_attach = on_attach },
  svelte = {},
  -- tailwindcss = {
  --   root_dir = function(fname)
  --     local root_pattern = require("lspconfig").util.root_pattern(
  --       "tailwind.config.cjs",
  --       "tailwind.config.js",
  --       "tailwind.config.ts",
  --       "postcss.config.js"
  --     )
  --     return root_pattern(fname)
  --   end,
  -- },
  cssls = {},
  vuels = {},
  rust_analyzer = {
    cmd = {
      "rustup",
      "run",
      "stable",
      "rust-analyzer",
    },
    settings = {
      ["rust-analyzer"] = {
        cargo = { buildScripts = { enable = true } },
        diagnostics = { enable = true },
        procMacro = { enable = true },
        checkOnSave = { command = "clippy" },
      }
    },
  },
  sqlls = {},
}

function M.setup()
  require('yap.config.lsp_new.installer').setup(servers)
end

return M
