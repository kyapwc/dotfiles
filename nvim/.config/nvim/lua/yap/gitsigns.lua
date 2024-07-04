require('gitsigns').setup({
  signs = {
    add          = {text = '+'},
    change       = {text = '-'},
    delete       = {text = '_'},
    topdelete    = {text = '‾'},
    changedelete = {text = '~'},
  },
  signcolumn = true,
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  preview_config = {
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1,
  },
  on_attach = function(bufNo)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufNo
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', '<leader>c', function()
      if vim.wo.diff then return '<leader>c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '<leader>C', function()
      if vim.wo.diff then return '<leader>C' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '<leader>gB', gs.toggle_current_line_blame)
    map('n', '<leader>dt', gs.diffthis)
  end,
})
