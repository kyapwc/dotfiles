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
-- Making <SPACE> as leader key
-- =======================
vim.g.mapleader = ' '
-- vim.g.colors_name = 'everforest'
-- vim.g.everforest_background = 'medium'
-- vim.g.everforest_better_performance = 1

-- ======================
-- Tokyonight config
-- ======================
vim.g.colors_name = 'tokyonight'
vim.g.tokyonight_style = 'storm' -- storm / night / day
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_lualine_bold = true

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
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.background = 'dark'
o.splitbelow = true
o.splitright = true
o.ignorecase = true


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
key_mapper('n', '<space>t', ':Vista!!<CR>')

-- =======================
-- Easier scrolling
-- =======================
key_mapper('', '<leader>j', '20j')
key_mapper('', '<leader>k', '20k')

-- =======================
-- Vim -> TMUX Navigation
-- =======================
key_mapper('n', '<C-h>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateLeft()<CR>')
key_mapper('n', '<C-j>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateDown()<CR>')
key_mapper('n', '<C-k>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateUp()<CR>')
key_mapper('n', '<C-l>', ':lua require("nvim-tmux-navigation").NvimTmuxNavigateRight()<CR>')

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

require('yap/plugins')
require('yap/treesitter')
require('yap/fzf-lua')
require('yap/lualine')
require('yap/bufferline')
require('yap/indent-blankline')
require('yap/config/lsp')
require('yap/coq')
require('yap/gitsigns')
require('yap/ultisnips')
require('yap/vim-go')
require('yap/fterm')
require('yap/minimap')
-- require('yap/orgmode')
