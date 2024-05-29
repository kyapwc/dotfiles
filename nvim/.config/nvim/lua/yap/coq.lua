local npairs = require('nvim-autopairs')
-- local remap = vim.api.nvim_set_keymap
local coq = require('coq')

npairs.setup({ map_bs = false, map_cr = false })

vim.g.coq_settings = {
  auto_start = 'shut-up',
  keymap = {
    jump_to_mark = '',
    eval_snips = '',
    bigger_preview = '<C-b>',
    recommended = false,
  },
  match = {
    max_results = 10,
  },
  clients = {
    snippets = {
      warn = {},
      enabled = false,
    },
  },
}

vim.cmd[[
  ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
  ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
  ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
  ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
  ino <silent><expr> <C-n>   pumvisible() ? "\<C-n>" : "\<Tab>"
  ino <silent><expr> <C-p>   pumvisible() ? "\<C-p>" : "\<BS>"
]]


-- skip it, if you use another global object
-- _G.MUtils= {}

-- MUtils.CR = function()
--   if vim.fn.pumvisible() ~= 0 then
--     if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
--       return npairs.esc('<c-y>')
--     else
--       return npairs.esc('<c-e>') .. npairs.autopairs_cr()
--     end
--   else
--     return npairs.autopairs_cr()
--   end
-- end
-- remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })
--
-- MUtils.BS = function()
--   if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
--     return npairs.esc('<c-e>') .. npairs.autopairs_bs()
--   else
--     return npairs.autopairs_bs()
--   end
-- end
-- remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

vim.cmd('COQnow --shut-up')
