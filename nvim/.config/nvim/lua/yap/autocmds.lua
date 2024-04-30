local notify = require('notify')

local api = vim.api

local nestGroup = api.nvim_create_augroup('NestGroup', { clear = true })
-- api.nvim_create_autocmd({ 'BufEnter' }, {
--   pattern = '*.service.ts',
--   callback = function()
--     local bufNo = api.nvim_get_current_buf()
--
--     local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--     if #lines > 1 then
--       return
--     end
--
--     if vim.api.nvim_get_mode().mode == "t" then
--       local escape = vim.api.nvim_replace_termcodes("<Esc>i", true, false, true)
--       vim.api.nvim_feedkeys(escape, "n", false)
--     end
--
--     local windowNo = api.nvim_get_current_win()
--     vim.ui.input({
--       prompt = 'Class name',
--     }, function(input)
--       if input ~= nil then
--         api.nvim_buf_set_lines(bufNo, 0, 0, false, {
--           [[import { Injectable } from '@nestjs/common';]],
--           [[]],
--           [[@Injectable()]],
--           [[export class ]] .. input .. [[ {}]],
--         })
--
--         api.nvim_win_set_cursor(windowNo, { 4, 13 })
--       end
--     end)
--     -- api.nvim_win_set_cursor(windowNo, { 4, 13 })
--     -- api.nvim_input('ve')
--   end,
--   group = nestGroup,
--   once = true,
-- })
