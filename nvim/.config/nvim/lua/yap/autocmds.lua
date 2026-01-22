-- =======================
-- Misc vim autocmds
-- =======================
vim.cmd [[
  tnoremap <Esc> <C-\><C-n>
  autocmd Filetype python setlocal ts=2 sw=2 expandtab
  nnoremap <expr> j v:count ? 'j' : 'gj'
  nnoremap <expr> k v:count ? 'k' : 'gk'
  autocmd FileType python map <buffer> <F9> :exec '!python3.11' shellescape(@%, 1)
  let g:python3_host_prog = '/opt/homebrew/bin/python3.11'
  nnoremap <silent> <C-6> <C-^>
  set noswapfile
]]

-- =======================
-- Setting sh filetype to bash
-- =======================
vim.cmd([[
  augroup _astro
  autocmd!
  autocmd BufRead,BufEnter *.sh set filetype=bash
  augroup end
]])

-- =======================
-- Splitjoin config
-- =======================
vim.cmd [[
  let g:splitjoin_trailing_comma = 1
]]

-- ======================
-- Tokyonight config
-- ======================
vim.cmd [[
  colorscheme tokyonight
]]

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimport()
  end,
  group = format_sync_grp,
})

local prismaSyncGrp = vim.api.nvim_create_augroup("PrismaSyncGrp", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.prisma",
  callback = function()
    vim.lsp.buf.format()
  end,
  group = prismaSyncGrp,
})

vim.cmd [[
  inoremap <silent><expr> <CR> pumvisible() ? "\<C-y><CR>" : "\<CR>"
  set scrolloff=5
]]

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    local groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "Float",
      "FloatBorder",
      "SignColumn",
      "GitSignsAdd",
      "GitSignsChange",
      "GitSignsDelete",
      -- "Pmenu",
      -- "PmenuSel",
      "WinSeparator",
      "TelescopeNormal",
      "TelescopeBorder",
      "TelescopeSelection",
      "TelescopePreviewNormal",
      "WhichKeyFloat",
    }

    for _, group in ipairs(groups) do
      -- vim.cmd("hi " .. group .. " ctermbg=None guibg=None")
      vim.cmd("hi " .. group .. " guibg=None")
    end

    return true
  end,
  desc = "Transparent backgrounds",
})


-- =======================
-- Misc vim autocmds
-- =======================
vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    vim.cmd("lua require('illuminate').resume()")
  end,
})

-- enable jsonc filetype for tsconfig.json and devcontainer.json
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "tsconfig.json", "devcontainer.json" },
  callback = function()
    vim.bo.filetype = "jsonc"
  end,
})
