local dap = require('dap')
local dap_ui = require('dapui')

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      vim.fn.stdpath("data") .. '/lazy/vscode-js-debug/dist/src/dapDebugServer.js',
      '${port}',
    },
  },
}

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "attach",
      processId = require 'dap.utils'.pick_process,
      name = "Attach debugger to existing `node --inspect` process",
      sourceMaps = true,
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**"
      },
      cwd = "${workspaceFolder}/src",
      skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file in new node process",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Docker Node.js",
      address = "127.0.0.1",
      port = 9229,
      restart = true,
      localRoot = vim.fn.getcwd(),
      remoteRoot = "/app",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "**/node_modules/**" },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**"
      },
    }
  }
end

dap_ui.setup({
  layouts = {
    {
      elements = {
        -- 'hover',
        'scopes',
        'watches',
        -- 'breakpoints',
        -- 'stacks',
        -- 'watches',
      },
      size = 40,
      position = 'left',
    },
    {
      elements = {
        'repl',
        --    'console',
      },
      size = 10,
      position = 'bottom',
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap_ui.open({ reset = true })
end
dap.listeners.before.event_terminated["dapui_config"] = dap_ui.close
dap.listeners.before.event_exited["dapui_config"] = dap_ui.close
