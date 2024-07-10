local M = {}

local uname_command = io.popen('uname')
local OS = nil

if uname_command ~= nil then
  OS = uname_command:read('*a')
  OS = OS:gsub("%s+", "")
  uname_command:close()
end

M.OS = OS

return M
