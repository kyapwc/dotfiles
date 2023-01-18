local util = require"vim.lsp.util"

local M = {}

-- shows doc in a buffer below
M.hover = function()
  vim.lsp.buf_request(0, 'textDocument/hover', util.make_position_params(), function(_, result, ctx, config)
    config = config or {}
    config.focus_id = ctx.method
    if not (result and result.contents) then
      -- return { 'No information available' }
      return
    end
    local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
    -- trims beg and end of whole content
    markdown_lines = util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      return
    end

    -- print(dump(markdown_lines))
    vim.api.nvim_command [[ new ]]
    vim.api.nvim_buf_set_lines(0, 0, 1, false, markdown_lines)
    vim.api.nvim_command [[ setlocal ft=markdown ]]
    vim.api.nvim_command [[ nnoremap <buffer>q <C-W>c ]]
    vim.api.nvim_command [[ setlocal buftype+=nofile ]]
    vim.api.nvim_command [[ setlocal nobl ]]
    vim.api.nvim_command [[ setlocal conceallevel=2 ]]
    vim.api.nvim_command [[ setlocal concealcursor+=n ]]
    -- vim.api.nvim_command [[ setlocal ft=lsp_markdown ]]
  end)
end

return M
