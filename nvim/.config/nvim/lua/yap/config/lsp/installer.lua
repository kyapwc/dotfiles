local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local coq = require('coq')

local M = {}

function M.setup(servers)
  local config = {
    function(server_name)
      lspconfig[server_name].setup({})
    end,
  }

  local mason_config = {
    ensure_installed = { 'eslint' },
  }

  for server_name, server_options in pairs(servers or {}) do
    table.insert(mason_config.ensure_installed, server_name)

    config[server_name] = function()
      lspconfig[server_name].setup(coq.lsp_ensure_capabilities(server_options))
    end
  end

  -- notify(vim.inspect(ensure_installed), vim.log.levels.INFO)

  mason_lspconfig.setup(mason_config)
  mason_lspconfig.setup_handlers(config)
end

return M
