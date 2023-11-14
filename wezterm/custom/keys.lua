local wezterm = require('wezterm')
local act = wezterm.action
local smart_splits = require('custom/smart-splits')

local keys = {
  { key = 'a', mods = 'LEADER', action = act.SendKey({ key = 'a', mods = 'CTRL' }) },
  { key = 'y', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Tab actions
  { key = 'c', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentTab({ confirm = true }) },
  { key = 't', mods = 'LEADER', action = act.ShowTabNavigator },

  -- Pane configs
  { key = '|', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = '-', mods = 'LEADER', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane({ confirm = true }) },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection('Up') },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection('Right') },

  smart_splits.split_nav('move', 'h'),
  smart_splits.split_nav('move', 'j'),
  smart_splits.split_nav('move', 'k'),
  smart_splits.split_nav('move', 'l'),

  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  { key = 'p', mods = 'LEADER', action = act.ActivateCommandPalette },

  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable({ name = 'resize_pane', one_shot = false }) },

  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
  },

  {
    key = '.',
    mods = 'LEADER',
    action = act.PromptInputLine({
      description = 'Enter a new name for current workspace',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.run_child_process({
            '/opt/homebrew/bin/wezterm',
            'cli',
            'rename-workspace',
            line,
          })
        end
      end)
    }),
  },

  { key = ' ', mods = 'LEADER', action = act.QuickSelect },

  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine({
      description = 'Enter a new name for current tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end)
    }),
  }
}

return keys
