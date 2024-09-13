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
-- P(lazypath) -- disable printing of lazy path
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

-- ======================
-- Tokyonight config
-- ======================
require('yap/tokyonight')
vim.cmd [[
  colorscheme tokyonight
]]
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
o.completeopt = 'menuone,noinsert,noselect'
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
opt.cursorline = true
opt.guicursor = "n-v-c-i:block"
opt.termguicolors = true
opt.mouse = ""

-- =======================
-- Custom Functions
-- =======================
local key_mapper = function(mode, key, result, desc)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    { noremap = true, silent = true, desc = desc }
  )
end

-- local git_push = function()
--  local branchHead = fugitive#Head()
--  execute ':Git push origin '..branchHead
-- end

-- =======================
-- Unmap arrow keys
-- =======================
key_mapper('', '<up>', '<nop>', 'Disable up arrow key')
key_mapper('', '<down>', '<nop>', 'Disable down arrow key')
key_mapper('', '<left>', '<nop>', 'Disable left arrow key')
key_mapper('', '<right>', '<nop>', 'Disable right arrow key')

-- =======================
-- Git-related mappings
-- =======================
key_mapper('n', '<space>gs', ':Git<CR>', 'Git Status')
key_mapper('n', '<space>gp', ':Git push<CR>', 'Git push')
key_mapper('n', '<space>gb', ':Git blame<CR>', 'Git blame')
key_mapper('n', '<space>gC', ':Git commit<CR>', 'Git commit')

-- =======================
-- FZF / Treesitter mappings
-- =======================
-- key_mapper('n', '<C-p>', ':lua require("telescope.builtin").find_files()<CR>')
-- key_mapper('n', '<leader>fs', ':lua require("telescope.builtin").live_grep()<CR>')
key_mapper('n', '<C-p>', ':lua require("fzf-lua").files()<CR>', 'FZF lua files')
key_mapper('n', '<C-f>', ':lua require("fzf-lua").live_grep_native()<CR>', 'FZF Live Grep')
key_mapper('n', '<space>a', ':lua require("fzf-lua").lsp_code_actions()<CR>', 'FZF LSP Code Actions')
key_mapper('n', '<space>lr', ':lua require("fzf-lua").lsp_references()<CR>', 'LSP Code references')
key_mapper('n', '<space>u', ':lua require("fzf-lua").oldfiles()<CR>', 'Recent files')

-- =======================
-- Misc Mappings
-- =======================
key_mapper('n', '<leader>z', ':qa<CR>', 'Quit all')
key_mapper('n', '<C-c>', ':bd<CR>', 'Close buffer')
key_mapper('n', '<leader>w', ':w<CR>', 'Save file')
key_mapper('n', '<leader>q', ':bd<CR>', 'Close window')
key_mapper('n', '<leader>ms', ':mksession! ~/.config/nvim/vim-session.vim<CR>')
key_mapper('n', '<leader>dd', ':lua vim.diagnostic.disable()<CR>', 'Disable diagnostics')
key_mapper('n', '<leader>de', ':lua vim.diagnostic.enable()<CR>', 'enable diagnostics')
key_mapper('n', '<space>rl', ':LspRestart<CR>', 'Restart LSP')

if IS_LINUX() then
  key_mapper('v', '<C-c>', '"*y', 'Linux copy to clipboard')
  key_mapper('v', '<C-c>', '"+y', 'Linux copy to clipboard')
else
  key_mapper('v', '<C-c>', '"+y', 'Macos copy to clipboard')
end

-- =======================
-- Easier scrolling
-- =======================
key_mapper('', '<leader>j', '20j', 'Lazy-man scrolling')
key_mapper('', '<leader>k', '20k', 'Lazy-man scrolling')

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
key_mapper('n', '<leader>1', ':lua require("bufferline").go_to_buffer(1, true)<CR>', 'Go to Buffer 1')
key_mapper('n', '<leader>2', ':lua require("bufferline").go_to_buffer(2, true)<CR>', 'Go to Buffer 2')
key_mapper('n', '<leader>3', ':lua require("bufferline").go_to_buffer(3, true)<CR>', 'Go to Buffer 3')
key_mapper('n', '<leader>4', ':lua require("bufferline").go_to_buffer(4, true)<CR>', 'Go to Buffer 4')
key_mapper('n', '<leader>5', ':lua require("bufferline").go_to_buffer(5, true)<CR>', 'Go to Buffer 5')
key_mapper('n', '<leader>6', ':lua require("bufferline").go_to_buffer(6, true)<CR>', 'Go to Buffer 6')
key_mapper('n', '<leader>7', ':lua require("bufferline").go_to_buffer(7, true)<CR>', 'Go to Buffer 7')
key_mapper('n', '<leader>8', ':lua require("bufferline").go_to_buffer(8, true)<CR>', 'Go to Buffer 8')
key_mapper('n', '<leader>9', ':lua require("bufferline").go_to_buffer(9, true)<CR>', 'Go to Buffer 9')
key_mapper('n', '<leader>0', ':lua require("bufferline").go_to_buffer(10, true)<CR>', 'Go to Buffer 10')

-- =======================
-- Goto Preview
-- =======================
key_mapper('n', '<leader>gt', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
  'Preview function definition')
key_mapper('n', '<leader>gg', "<cmd>lua require('goto-preview').close_all_win()<CR>", 'Close all preview windows')


-- =======================
-- Close all buffer except current
-- =======================
key_mapper('n', '<leader>bx', '::%bd|e#<CR>', 'Close all buffer except for current')

-- =======================
-- Extras
-- =======================
-- key_mapper('i', ';;', "&nbsp;")
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   command = 'silent! EslintFixAll',
--   -- command = 'EslintFixAll',
--   group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
-- })
vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

vim.cmd('FzfLua register_ui_select')

vim.cmd [[
  if exists("g:neovide")
    " set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h10
    " set guifont=FiraCode\ Nerd\ Font\ Mono:h10
    set guifont=Monaspace\ Radon:h10
    let g:neovide_theme = 'tokyonight-moon'
    let g:neovide_transparency = 0.6
    let g:transparency = 0.9
    let g:neovide_cursor_animation_length = 0.05
    let g:neovide_window_blurred = v:true
    let g:neovide_padding_top = 10
    let g:neovide_padding_bottom = 10
    let g:neovide_padding_right = 10
    let g:neovide_padding_left = 10
  endif
]]

local function switch_case()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local word = vim.fn.expand('<cword>')
  local word_start = vim.fn.matchstrpos(vim.fn.getline('.'), '\\k*\\%' .. (col + 1) .. 'c\\k*')[2]

  if word:find('[a-z][A-Z]') then
    local snake_case_word = word:gsub('([a-z])([A-Z])', '%1_%2'):lower()
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { snake_case_word })
  elseif word:find('_[a-z]') then
    local camel_case_word = word:gsub('(_)([a-z])', function(_, l) return l:upper() end)
    vim.api.nvim_buf_set_text(0, line - 1, word_start, line - 1, word_start + #word, { camel_case_word })
  else
    print('Not a snake_case or camelCase word')
  end
end

vim.keymap.set('n', '<Space>ss', switch_case, { noremap = true, silent = true })
-- vim.opt.termguicolors = true

-- require('yap/noice')
require('yap/autocmds')
require('yap/gitsigns')
require('yap/telescope')
require('yap/retrail')
require('yap/treesitter')
require('yap/twilight')
require('yap/fzf-lua')
require('yap/lualine')
require('yap/bufferline')
require('yap/indent-blankline')
require('yap/config/lsp_new').setup()
require('yap/config/lsp_new/cmp')
require('yap/vim-go')
require('yap/minimap')
-- require('yap/gojira')
require('yap/alpha')
require('yap/luasnip')
require('yap/oil')
require('yap/smart-splits')
require('yap/peek')
require('yap/autotag')
require('yap/navic')
require('yap/whichkey')
require('yap/goto-preview')
require('yap/aerial')
require('yap/lint')
require('yap/conform')
require('yap/toggle-term')
require('yap/neotest')

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPre", "BufNewFile" }, {
  callback = function()
    local signs = {
      { name = 'DiagnosticSignError', text = 'E' },
      { name = 'DiagnosticSignWarn',  text = 'W' },
      { name = 'DiagnosticSignHint',  text = 'H' },
      { name = 'DiagnosticSignInfo',  text = 'I' },
    }

    local vimDiagnosticConfig = {
      virtual_text = false, -- disable virtual text
      signs = {
        active = signs,     -- show signs
      },
      update_in_insert = true,
      underline = true,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    }

    vim.diagnostic.config(vimDiagnosticConfig)

    -- Set diagnostic signs
    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end
  end,
  group = vim.api.nvim_create_augroup("DiagnosticConfigOnSave", { clear = true }),
  desc = "Set diagnostic configuration after file save",
})
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
