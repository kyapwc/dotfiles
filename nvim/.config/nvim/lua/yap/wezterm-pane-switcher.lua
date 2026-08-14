-- Lightweight replacement for smart-splits.nvim's WezTerm integration.
--
-- smart-splits.nvim's wezterm backend shells out to the `wezterm` CLI binary
-- (up to 6 times per pane switch) to move focus into WezTerm when Neovim is
-- at the edge of its window layout. Each `wezterm cli` invocation has a fixed
-- ~100ms process-startup cost, so a single edge-crossing keypress could take
-- 500ms+. Signaling WezTerm via an OSC 1337 escape sequence (same mechanism
-- the plugin already used to set the IS_NVIM user var) is effectively free.

local function osc_set_user_var(name, value)
  local seq = string.format('\027]1337;SetUserVar=%s=%s\007', name, vim.base64.encode(value))
  if vim.fn.filewritable('/dev/fd/2') == 1 then
    vim.fn.writefile({ seq }, '/dev/fd/2', 'b')
  else
    vim.fn.chansend(vim.v.stderr, seq)
  end
end

local function set_is_nvim(value)
  osc_set_user_var('IS_NVIM', value)
end

local group = vim.api.nvim_create_augroup('YapSmartSplits', { clear = true })

set_is_nvim('true')

vim.api.nvim_create_autocmd('VimResume', {
  group = group,
  callback = function() set_is_nvim('true') end,
})

vim.api.nvim_create_autocmd({ 'VimSuspend', 'VimLeavePre' }, {
  group = group,
  callback = function() set_is_nvim('false') end,
})

local directions = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function move(key)
  local winnr_before = vim.fn.winnr()
  vim.cmd('wincmd ' .. key)
  if vim.fn.winnr() == winnr_before then
    -- No more Neovim windows in that direction; ask WezTerm to move focus.
    osc_set_user_var('SMARTSPLITS_MOVE', directions[key])
  end
end

vim.keymap.set('n', '<C-h>', function() move('h') end)
vim.keymap.set('n', '<C-j>', function() move('j') end)
vim.keymap.set('n', '<C-k>', function() move('k') end)
vim.keymap.set('n', '<C-l>', function() move('l') end)
