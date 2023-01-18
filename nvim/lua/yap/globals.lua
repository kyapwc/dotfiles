P = function(value)
  print(vim.inspect(value))
  return value
end

Trim = function(value)
  return value:gsub('%s+', '')
end
