local vim = vim

P = function(value)
  print(vim.inspect(value))
  return value
end

Trim = function(value)
  return value:gsub('%s+', '')
end

KEY_MAPPER = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    { noremap = true, silent = true }
  )
end

GenUUID = function()
  local handle = io.popen([[uuidgen | tr 'A-Z' 'a-z' | tr -d '\n']])
  if handle == nil then
    return ''
  end

  local result = handle:read("*a")

  handle:close()
  return result
end

SLEEP = function(seconds)
  os.execute('sleep ' .. tonumber(seconds))
end

OS_NAME = function()
  local OS_NAME = vim.loop.os_uname().sysname

  return OS_NAME
end

IS_LINUX = function()
  local osName = OS_NAME()
  return osName == 'Linux'
end
