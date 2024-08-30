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
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({
    lsp_format = "fallback",
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })
