local toggleterm = require("toggleterm")

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

toggleterm.setup({
  shade_terminals = false,
  insert_mappings = true,
  persist_mode = true,
  highlights = {
    StatusLine = { guifg = "#ffffff", guibg = "#0E1018" },
    StatusLineNC = { guifg = "#ffffff", guibg = "#0E1018" }
  }
})

vim.keymap.set('n', '<leader><leader>', ':ToggleTerm size=15<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':ToggleTerm size=70 direction=vertical<CR>', { noremap = true, silent = true })

vim.opt.laststatus = 3

local Terminal     = require('toggleterm.terminal').Terminal
local lazygit      = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = 'float',
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    -- set esc to <esc>
    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<esc>", { noremap = true, silent = true })

    -- set i to <nop>
    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "i", "<nop>", { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap("n", "<space>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
