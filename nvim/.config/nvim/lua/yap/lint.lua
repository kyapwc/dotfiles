local lint = require('lint')

local function has_eslint_config()
  local eslint_files = {
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'package.json'
  }

  for _, file in ipairs(eslint_files) do
    if vim.fn.filereadable(vim.fn.getcwd() .. '/' .. file) == 1 then
      -- Check if package.json contains eslintConfig
      if file == 'package.json' then
        local content = vim.fn.readfile(vim.fn.getcwd() .. '/' .. file)
        local json = vim.fn.json_decode(table.concat(content, '\n'))
        if json and json.eslintConfig then
          return true
        end
      else
        return true
      end
    end
  end

  return false
end

lint.linters_by_ft = {
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  svelte = { "eslint_d" },
  kotlin = { "ktlint" },
  terraform = { "tflint" },
  ruby = { "standardrb" },
}


local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    local eslint_filetypes = {
      'javascript',
      'typescript',
      'javascriptreact',
      'typescriptreact'
    }

    if vim.tbl_contains(eslint_filetypes, vim.bo.filetype) then
      if has_eslint_config() then
        lint.try_lint()
      end
    end
  end,
})

vim.keymap.set("n", "<leader>ll", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })
