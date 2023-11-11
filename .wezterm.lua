local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Tab Bar styling
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
    background = '#3c1361',

    active_tab = {
      bg_color = '#ff79c6',
      fg_color = 'white',
      italic = false,
    },

    inactive_tab = {
      bg_color = '#2A0D43',
      fg_color = 'grey',
      italic = true,
    }
  }
}

-- Window Statuses
wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  if window:leader_is_active() then
    table.insert(cells, 'LDR')
  end

  table.insert(cells, '  ' .. window:active_workspace() .. ' ')

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = ''

    if type(cwd_uri) == 'userdata' then
      -- Running on a newer version of wezterm and we have
      -- a URL object here, making this simple!

      cwd = cwd_uri.file_path
    else
      -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
      -- which doesn't have the Url object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find '/'
      if slash then
        -- and extract the cwd from the uri, decoding %-encoding
        cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
          return string.char(tonumber(hex, 16))
        end)

        if cwd:sub(1, 13) == "/Users/kenyap" then
          cwd = "~" .. cwd:sub(14)
        end
      end
    end

    table.insert(cells, '  ' .. wezterm.nerdfonts.md_folder .. '  ' .. cwd)
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  local date = wezterm.strftime '%a %b %-d %H:%M:%S'
  table.insert(cells, wezterm.nerdfonts.md_clock .. '  ' .. date)

  -- An entry for each battery (typically 0 or 1 battery)
  for _, b in ipairs(wezterm.battery_info()) do
    local battery_state = b.state_of_charge * 100
    local batt_icon = wezterm.nerdfonts.fa_battery_empty
    if battery_state <= 20 then
      batt_icon = wezterm.nerdfonts.fa_battery_quarter
    elseif battery_state > 20 and battery_state <= 50 then
      batt_icon = wezterm.nerdfonts.fa_battery_half
    elseif battery_state > 50 and battery_state <= 75 then
      batt_icon = wezterm.nerdfonts.fa_battery_three_quarters
    else
      batt_icon = wezterm.nerdfonts.fa_battery_full
    end
    wezterm.log_info(batt_icon)

    table.insert(cells, batt_icon .. ' ' .. string.format('%.0f%%', battery_state))
  end

  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  local function push(text, is_last)
    local cell_no = num_cells + 1
    if text == 'LDR' then
      table.insert(elements, { Foreground = { Color = 'red' } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
      table.insert(elements, { Background = { Color = 'red' } })
      table.insert(elements, { Foreground = { Color = 'white' } })
      table.insert(elements, { Text = ' ' .. text .. ' ' })
    else
      table.insert(elements, { Foreground = { Color = text_fg } })
      table.insert(elements, { Background = { Color = colors[cell_no] } })
      table.insert(elements, { Text = ' ' .. text .. ' ' })
    end

    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)
config.status_update_interval = 500

-- Colorschemeas and font
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font_with_fallback({
  {
    family = 'Monaspace Radon',
    weight = 'ExtraBold',
    harfbuzz_features = { 'liga=1' },
  },
})

-- Settings
config.window_decorations = 'RESIZE'
-- config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 5,
  right = 5,
  top = 0,
  bottom = 0,
}
config.window_background_opacity = 0.95
config.window_close_confirmation = 'AlwaysPrompt'
config.scrollback_lines = 3000
config.default_workspace = 'HOME'
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.5,
}

-- Keys
config.leader = {
  key = ']',
  timeout_milliseconds = 1000,
}
config.keys = {
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
  { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection('Left') },
  { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection('Down') },
  { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection('Up') },
  { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection('Right') },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  { key = 'p', mods = 'LEADER', action = act.ActivateCommandPalette },

  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable({ name = 'resize_pane', one_shot = false }) },

  {
    key = '9',
    mods = 'LEADER',
    action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
  },
}

config.key_tables = {
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize({ 'Left', 5 }) },
    { key = 'j', action = act.AdjustPaneSize({ 'Down', 2 }) },
    { key = 'k', action = act.AdjustPaneSize({ 'Up', 2 }) },
    { key = 'l', action = act.AdjustPaneSize({ 'Right', 5 }) },
    { key = 'Escape', action = 'PopKeyTable' },
  }
}

for i = 1, 8 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = act.ActivateTab(i - 1)
  })
end

return config
