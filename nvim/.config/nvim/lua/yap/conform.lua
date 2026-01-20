local conform = require('conform')

local function has_prettier_config()
  local config_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json", "prettier.config.js", "prettier.config.cjs" }

  for _, file in ipairs(config_files) do
    if vim.fn.filereadable(vim.fn.getcwd() .. '/' .. file) == 1 then
      return true
    end
  end
  return false
end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    svelte = { { "prettierd", "prettier" } },
    javascript = has_prettier_config() and { "prettierd", "prettier", stop_after_first = true } or {},
    typescript = has_prettier_config() and { "prettierd", "prettier", stop_after_first = true } or {},
    javascriptreact = has_prettier_config() and { "prettierd", "prettier", stop_after_first = true } or {},
    typescriptreact = has_prettier_config() and { "prettierd", "prettier", stop_after_first = true } or {},
    -- json = { { "prettierd", "prettier" } },
    graphql = { { "prettierd", "prettier" } },
    java = { "google-java-format" },
    kotlin = { "ktlint" },
    ruby = { "standardrb" },
    markdown = { { "prettierd", "prettier" } },
    erb = { "htmlbeautifier" },
    html = { "htmlbeautifier" },
    bash = { "beautysh" },
    proto = { "buf" },
    rust = { "rustfmt" },
    yaml = { "yamlfix" },
    toml = { "taplo" },
    css = { { "prettierd", "prettier" } },
    scss = { { "prettierd", "prettier" } },
    -- disable golang formatter and let gopls do its work
    -- go = {}
  },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({
    lsp_format = "fallback",
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })
