local vim = vim

P = function(value)
  print(vim.inspect(value))
  return value
end

Trim = function(value)
  return value:gsub('%s+', '')
end

KEY_MAPPER = function(mode, key, result, desc)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    { noremap = true, silent = true, desc = desc }
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

IS_DEVCONTAINER = function()
  -- Strong Docker signal
  if vim.loop.fs_stat("/.dockerenv") then
    return true
  end

  -- cgroup heuristic
  local cgroup = "/proc/1/cgroup"
  local fd = io.open(cgroup, "r")
  if fd then
    local content = fd:read("*a") or ""
    fd:close()
    if content:match("docker") or content:match("containerd") or content:match("kubepods") then
      return true
    end
  end

  return false
end
