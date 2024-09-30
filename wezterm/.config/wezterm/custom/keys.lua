local wezterm = require('wezterm')
local smart_splits = require('custom/smart-splits')
local utils = require('custom/utils')

local act = wezterm.action

local function get_process_id(command)
  local success, stdout = wezterm.run_child_process(command)

  if success == true then
    return stdout:gsub('\n', '')
  end

  return nil
end

local function handle_nats_redis_create(window)
  local project_dir = '~/go/src/bitbucket.org/pick-up/pickupp'
  local mux_window = window:mux_window()
  local nats_id = get_process_id({
    'lsof',
    '-i',
    ':4222',
    '-t',
  })
  local redis_id = get_process_id({
    'lsof',
    '-i',
    ':6379',
    '-t',
  })

  -- kill process individually if it fail to kill in the below else statement
  if nats_id ~= nil and redis_id == nil then
    wezterm.run_child_process({
      'kill',
      '-9',
      nats_id,
    })
  end

  -- kill process individually if it fail to kill in the below else statement
  if redis_id ~= nil and nats_id == nil then
    wezterm.run_child_process({
      'kill',
      '-9',
      redis_id,
    })
  end

  if nats_id == nil and redis_id == nil then
    local tab, nats_pane = mux_window:spawn_tab({
      cwd = project_dir,
      set_environment_variables = {
        TYPE = 'AUTOMATED',
      },
    })

    tab:set_title('Nats-Redis')

    local redis_pane = nats_pane:split({
      direction = 'Right',
      cwd = project_dir,
    })
    redis_pane:send_text('redis-server\n')

    nats_pane:send_text('nats-server -js\n')
  else
    local tabs = mux_window:tabs()
    wezterm.run_child_process({
      'kill',
      '-9',
      nats_id,
    })
    wezterm.run_child_process({
      'kill',
      '-9',
      redis_id,
    })

    for _, tab in ipairs(tabs) do
      if tab:get_title() == 'Nats-Redis Server' then
        tab:activate()
        for _, pane in ipairs(tab:panes()) do
          wezterm.run_child_process({
            '/opt/homebrew/bin/wezterm',
            'cli',
            'kill-pane',
            '--pane-id',
            pane:pane_id(),
          })
        end
      end
    end
  end
end

local keys = {
  { key = 'a', mods = 'LEADER', action = act.SendKey({ key = 'a', mods = 'CTRL' }) },
  { key = 'y', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Tab actions
  { key = 'c', mods = 'LEADER', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w', mods = 'CMD',    action = act.CloseCurrentTab({ confirm = true }) },
  { key = 't', mods = 'LEADER', action = act.ShowTabNavigator },
  { key = ']', mods = 'LEADER', action = act.SendString(']') },

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

  { key = ' ',          mods = 'LEADER',       action = act.QuickSelect },

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
  },

  { key = "LeftArrow",  mods = "OPT",          action = act.SendString('\x1bb') },

  { key = "RightArrow", mods = "OPT",          action = act.SendString('\x1bf') },

  { key = 'Backspace',  mods = 'CMD',          action = act.SendString('\x15') },

  -- below is keybinds for normal zsh or bash
  -- disable if shell is fish
  { key = 'LeftArrow',  mods = 'CMD',          action = act.SendString('\x1bOH') },
  { key = 'RightArrow', mods = 'CMD',          action = act.SendString('\x1bOF') },

  -- below is keybinds for fish shell
  -- { key = 'LeftArrow', mods = 'CMD', action = act.SendString('\x1bD') },
  -- { key = 'RightArrow', mods = 'CMD', action = act.SendString('\x1bC') },

  { key = 's',          mods = 'LEADER|SHIFT', action = wezterm.action_callback(handle_nats_redis_create) },

  --- wezterm session-manager events
  { key = 'h',          mods = "LEADER|SHIFT", action = wezterm.action { EmitEvent = 'save_session' } },
  { key = 'l',          mods = "LEADER|SHIFT", action = wezterm.action { EmitEvent = 'load_session' } },
  { key = 'r',          mods = "LEADER|SHIFT", action = wezterm.action { EmitEvent = 'restore_session' } },

  { key = '{',          mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = 'SwapWithActiveKeepFocus' }) },
}

if utils.OS == 'Linux' then
  table.insert(keys, { key = 'v', mods = 'CTRL', action = act.PasteFrom('PrimarySelection') })
  table.insert(keys, { key = '\\', mods = 'LEADER', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) })
end

return keys
