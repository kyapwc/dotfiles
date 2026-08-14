local wezterm = require('wezterm')

local M = {}

-- Set by Neovim (lua/yap/smart-splits.lua) via an OSC 1337 SetUserVar escape
-- sequence on startup, and unset on exit.
local function is_vim(pane)
  return pane:get_user_vars().IS_NVIM == 'true'
end

-- Neovim sends this (also via OSC 1337 SetUserVar) when Ctrl-hjkl hits the
-- edge of its window layout and there's nowhere left to move within Neovim.
-- This is a direct escape-sequence signal (no `wezterm cli` subprocess
-- involved), so it's effectively instant.
wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'SMARTSPLITS_MOVE' then
    window:perform_action(wezterm.action.ActivatePaneDirection(value), pane)
  end
end)

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

M.split_nav = function(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

return M
