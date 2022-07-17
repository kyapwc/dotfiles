vim.g.coq_settings = {
  auto_start = 'shut-up',
  keymap = {
    jump_to_mark = 'null',
    eval_snips = 'null',
  },
  clients = {
    snippets = {
      warn = {},
    },
  },
}

vim.cmd[[
  ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
  ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
  ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
  ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
  ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
]]

local coq = require('coq')

vim.cmd('COQnow')
