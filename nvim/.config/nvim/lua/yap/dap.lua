local dap = require('dap')
local dapui = require('dapui')
local widgets = require("dap.ui.widgets")

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

dapui.setup({
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
  dapui.open({ reset = true })
end
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

local dap_ui = function(widget, title)
  return function()
    widgets.cursor_float(widget, { title = title })
  end
end

vim.keymap.set(
  'n',
  '<leader>ds',
  dap_ui(widgets.scopes, "dap-scopes"),
  { noremap = true, silent = true, desc = "Dap Scopes" }
)

vim.keymap.set(
  'n',
  '<leader>df',
  dap_ui(widgets.frames, "dap-frames"),
  { noremap = true, silent = true, desc = "Dap Frames" }
)

vim.keymap.set(
  'n',
  '<leader>de',
  dap_ui(widgets.expression, "dap-expression"),
  { noremap = true, silent = true, desc = "Dap Expression" }
)

vim.keymap.set(
  'n',
  '<leader>dt',
  dap_ui(widgets.threads, "dap-threads"),
  { noremap = true, silent = true, desc = "Dap Threads" }
)

vim.keymap.set(
  'n',
  '<leader>dS',
  dap_ui(widgets.sessions, "dap-sessions"),
  { noremap = true, silent = true, desc = "Dap Sessions" }
)
