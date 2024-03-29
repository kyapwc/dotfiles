require('yap/globals')

-- =======================
-- Making <SPACE> as leader key
-- =======================
vim.g.mapleader = ' '
-- vim.g.colors_name = 'everforest'
-- vim.g.everforest_background = 'medium'
-- vim.g.everforest_better_performance = 1

-- =======================
-- Making , as localleader key
-- =======================
vim.g.maplocalleader = ','

local fn = vim.fn

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
P(lazypath)
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

-- =======================
-- Require impatient before every other config
-- =======================
require('impatient')

-- =======================
-- Local vim declaration
-- =======================
local vim = vim
local nvim_treesitter = require('nvim-treesitter')

-- =======================
-- Misc vim autocmds
-- =======================
vim.cmd[[
  tnoremap <Esc> <C-\><C-n>
  autocmd Filetype python setlocal ts=2 sw=2 expandtab
  nnoremap <expr> j v:count ? 'j' : 'gj'
  nnoremap <expr> k v:count ? 'k' : 'gk'
  autocmd FileType python map <buffer> <F9> :exec '!python3' shellescape(@%, 1)
  let g:python3_host_prog = '/usr/local/bin/python3'
  nnoremap <silent> <C-6> <C-^>
  set noswapfile
]]

-- =======================
-- Personal text objects
-- =======================
vim.cmd[[
  onoremap iq i'
  onoremap iQ i"
  onoremap aq a'
  onoremap aQ a"
  onoremap sq s'
  onoremap sQ s"
  onoremap , t,
  vnoremap iq i'
  vnoremap iQ i""
]]

-- =======================
-- Splitjoin config
-- =======================
vim.cmd[[
  let g:splitjoin_trailing_comma = 1
]]

-- ======================
-- Tokyonight config
-- ======================
require('yap/tokyonight')
vim.g.colors_name = 'tokyonight-moon'
vim.g.tokyonight_style = 'night' -- storm / night / day / moon
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_lualine_bold = true
-- vim.g.tokyonight_colors = { border = "#8D19C6" }
-- vim.cmd[[
--   highlight WinSeparator guifg=#8D19C6
--   highlight VertSplit guifg=#8D19C6
-- ]]

-- ======================
-- Catppuccin config
-- ======================
-- vim.cmd.colorscheme 'catppuccin'

-- ======================
-- TokyoDark config
-- ======================
-- vim.g.colors_name = 'tokyodark'
-- vim.g.tokyodark_transparent_background = false
-- vim.g.tokyodark_enable_italic = true
-- vim.g.tokyodark_enable_italic_comment = true
-- vim.g.tokyodark_color_gamma = '0.9'

-- ======================
-- Shades of Purple config
-- ======================
-- vim.g.colors_name = 'shades_of_purple'

-- =======================
-- Declaring Local Variables
-- vim.o = editor options
-- vim.bo = buffer options
-- vim.wo = window options
-- vim.go = global variables
-- vim.opt = global, window & buffer settings
-- =======================
local o = vim.o
local bo = vim.bo
local wo = vim.wo
local opt = vim.opt

-- =======================
-- Editor options
-- =======================
vim.opt.termguicolors = true
o.termguicolors = true
o.syntax = 'on'
o.errorbells = false
o.smartcase = true
o.showmode = false
o.backup = false
-- o.undodir = vim.fn.stdpath('config') .. '/undodir'
o.undofile = false
o.incsearch = true
o.hidden = true
o.completeopt='menuone,noinsert,noselect'
o.background = 'dark'
o.splitbelow = true
o.splitright = true
o.ignorecase = true
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true

-- =======================
-- Buffer options
-- =======================
bo.swapfile = false
bo.autoindent = true
bo.smartindent = true

-- =======================
-- Window options
-- =======================
wo.number = true
wo.relativenumber = true
wo.signcolumn = 'yes'
wo.wrap = true
wo.scrolloff = 8

-- wo.foldlevel = 20
-- wo.foldmethod = 'expr'
-- wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- =======================
-- Window options
-- =======================
-- opt.cursorline = true
opt.guicursor = "n-v-c-i:block"
opt.termguicolors = true
opt.mouse = ""

-- =======================
-- Custom Functions
-- =======================
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    { noremap = true, silent = true }
  )
end

-- local git_push = function()
--  local branchHead = fugitive#Head()
--  execute ':Git push origin '..branchHead
-- end

-- =======================
-- Unmap arrow keys
-- =======================
key_mapper('', '<up>', '<nop>')
key_mapper('', '<down>', '<nop>')
key_mapper('', '<left>', '<nop>')
key_mapper('', '<right>', '<nop>')

-- =======================
-- Git-related mappings
-- =======================
key_mapper('n', '<space>gs', ':Git<CR>')
key_mapper('n', '<space>gp', ':Git push<CR>')
key_mapper('n', '<space>gb', ':Git blame<CR>')
key_mapper('n', '<space>gC', ':Git commit<CR>')

-- =======================
-- FZF / Treesitter mappings
-- =======================
-- key_mapper('n', '<C-p>', ':lua require("telescope.builtin").find_files()<CR>')
-- key_mapper('n', '<leader>fs', ':lua require("telescope.builtin").live_grep()<CR>')
key_mapper('n', '<C-p>', ':lua require("fzf-lua").files()<CR>')
key_mapper('n', '<C-f>', ':lua require("fzf-lua").live_grep_native()<CR>')
key_mapper('n', '<C-a>', ':lua require("fzf-lua").lsp_code_actions()<CR>')

-- =======================
-- Misc Mappings
-- =======================
key_mapper('n', '<leader>z', ':qa<CR>')
key_mapper('n', '<C-c>', ':bd<CR>')
key_mapper('n', '<leader>w', ':w<CR>')
key_mapper('n', '<leader>q', ':bd<CR>')
key_mapper('n', '<C-\\>', ':CHADopen<CR>')
key_mapper('n', '<leader>ms', ':mksession! ~/.config/nvim/vim-session.vim<CR>')
key_mapper('n', '<leader>l', ':FocusSplitNicely<CR>')
key_mapper('v', '<C-c>', '"+y')
key_mapper('n', '<space>dd', ':lua vim.diagnostic.disable()<CR>')
key_mapper('n', '<space>de', ':lua vim.diagnostic.enable()<CR>')
key_mapper('n', '<space>v', ':Vista!!<CR>')
key_mapper('n', '<space>ss', ':lua vim.lsp.buf.signature_help()<CR>')
key_mapper('n', '<space>p', ':lua require("player").toggle_player()<CR>')

-- =======================
-- Easier scrolling
-- =======================
key_mapper('', '<leader>j', '20j')
key_mapper('', '<leader>k', '20k')

-- =======================
-- Vim -> TMUX Navigation
-- =======================
-- key_mapper('n', '<C-h>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateLeft()<CR>')
-- key_mapper('n', '<C-j>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateDown()<CR>')
-- key_mapper('n', '<C-k>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateUp()<CR>')
-- key_mapper('n', '<C-l>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateRight()<CR>')

-- =======================
-- Bufferline
-- =======================
key_mapper('n', '<leader>1', ':lua require("bufferline").go_to_buffer(1, true)<CR>')
key_mapper('n', '<leader>2', ':lua require("bufferline").go_to_buffer(2, true)<CR>')
key_mapper('n', '<leader>3', ':lua require("bufferline").go_to_buffer(3, true)<CR>')
key_mapper('n', '<leader>4', ':lua require("bufferline").go_to_buffer(4, true)<CR>')
key_mapper('n', '<leader>5', ':lua require("bufferline").go_to_buffer(5, true)<CR>')
key_mapper('n', '<leader>6', ':lua require("bufferline").go_to_buffer(6, true)<CR>')
key_mapper('n', '<leader>7', ':lua require("bufferline").go_to_buffer(7, true)<CR>')
key_mapper('n', '<leader>8', ':lua require("bufferline").go_to_buffer(8, true)<CR>')
key_mapper('n', '<leader>9', ':lua require("bufferline").go_to_buffer(9, true)<CR>')
key_mapper('n', '<leader>0', ':lua require("bufferline").go_to_buffer(10, true)<CR>')

-- =======================
-- Trouble
-- =======================
key_mapper('n', '<leader>tt', '<cmd>TroubleToggle<cr>')

-- =======================
-- Goto Preview
-- =======================
key_mapper('n', '<leader>gt', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
key_mapper('n', '<leader>gg', "<cmd>lua require('goto-preview').close_all_win()<CR>")


-- =======================
-- Extras
-- =======================
key_mapper('i', ';;', "&nbsp;")
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   command = 'silent! EslintFixAll',
--   -- command = 'EslintFixAll',
--   group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
-- })

vim.cmd[[
  if exists("g:neovide")
    " set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h10
    set guifont=FiraCode\ Nerd\ Font\ Mono:h10
    let g:neovide_transparency = 0.9
    let g:transparency = 0.9
    let g:neovide_cursor_animation_length = 0.01
  endif
]]

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.prisma",
  callback = function()
    vim.lsp.buf.format()
  end,
  group = format_sync_grp,
})

vim.cmd [[
  inoremap <silent><expr> <CR> pumvisible() ? "\<C-y><CR>" : "\<CR>"
  set scrolloff=5
]]

vim.api.nvim_create_autocmd("UIEnter", {
  callback = function ()
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

local function switch_case()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local word = vim.fn.expand('<cword>')
  local word_start = vim.fn.matchstrpos(vim.fn.getline('.'), '\\k*\\%' .. (col + 1) .. 'c\\k*')[2]

  if word:find('[a-z][A-Z]') then
    local snake_case_word = word:gsub('([a-z])([A-Z])', '%1_%2'):lower()
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
  elseif word:find('_[a-z]') then
    local camel_case_word = word:gsub('(_)([a-z])', function(_, l) return l:upper() end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, {camel_case_word})
  else
    print('Not a snake_case or camelCase word')
  end
end

vim.keymap.set('n', '<Space>ss', switch_case, {noremap = true, silent = true})

require('yap/telescope')
require('yap/retrail')
require('yap/treesitter')
require('yap/twilight')
require('yap/fzf-lua')
require('yap/lualine')
require('yap/bufferline')
require('yap/indent-blankline')
require('yap/coq')
require('yap/gitsigns')
require('yap/vim-go')
require('yap/fterm')
require('yap/minimap')
require('yap/gojira')
require('yap/alpha')
require('yap/formatter')
require('yap/luasnip')
require('yap/autocmds')
require('yap/dressing')
require('yap/oil')
require('yap/smart-splits')
-- require('yap/rest')
-- require('yap/inlay-hints')
-- require('fidget').setup({
--   debug = { logging = true }
-- })
-- require('yap/orgmode')

-- =======================
-- Tips for plugin development
-- =======================
-- :lua package.loaded['gojira.gojira'] = print(require('gojira.gojira'))
-- this is to reload the file into the stack on neovim without restart neovim
