local mason_lspconfig = require('mason-lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local M = {}

function M.setup(servers)
  -- 1) Tell mason-lspconfig what to install
  local ensure = {}
  for server_name, _ in pairs(servers or {}) do
    table.insert(ensure, server_name)
  end

  mason_lspconfig.setup({
    ensure_installed = ensure,
    -- automatic_enable defaults to true in v2, but being explicit is fine:
    automatic_enable = true,
  }) -- :contentReference[oaicite:1]{index=1}

  -- 2) Register configs with Neovim's native API
  for server_name, server_opts in pairs(servers or {}) do
    vim.lsp.config(server_name, vim.tbl_deep_extend("force", {
      capabilities = capabilities,
    }, server_opts or {}))
  end

  -- 3) If you want to be explicit (optional; mason-lspconfig will auto-enable installed servers by default):
  for _, server_name in ipairs(ensure) do
    vim.lsp.enable(server_name)
  end
end

return M
