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
