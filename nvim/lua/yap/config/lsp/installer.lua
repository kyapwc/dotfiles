local lsp_installer_servers = require('nvim-lsp-installer.servers')

local M = {}

function M.setup(servers, options)
  for server_name, _ in pairs(servers or {}) do
    local server_available, server = lsp_installer_servers.get_server(server_name)

    if server_available then
      server:on_ready(function()
        local opts = vim.tbl_deep_extend('force', options, servers[server.name] or {})

        local coq = require('coq')
        server:setup(coq.lsp_ensure_capabilities(opts))

        -- server:setup(opts)
      end)

      if not server:is_installed() then
        vim.notify('Installing ' .. server.name, vim.log.levels.INFO)
        server:install()
      end
    else
      vim.notify('Installing ' .. server.name, vim.log.levels.ERROR)
    end
  end
end

return M
