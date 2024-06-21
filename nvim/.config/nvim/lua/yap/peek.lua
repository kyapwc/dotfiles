local peek = require('peek')

local OS_NAME = vim.loop.os_uname().sysname
local app = nil

if OS_NAME == "Linux" then
  app = 'browser'
else
  app = 'webview'
end

peek.setup({
  auto_load = true,
  close_on_bdelete = true,
  syntax = true,
  theme = 'dark',
  update_on_change = true,
  app = app,
  filetype = { 'markdown' },
  throttle_at = 200000,
  throttle_time = 'auto',
})
