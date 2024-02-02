local wezterm = require 'wezterm'

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
    local charging_state = b.state
    local battery_state = b.state_of_charge * 100
    local batt_icon = wezterm.nerdfonts.fa_battery_empty
    if (charging_state == 'Charging' or charging_state == 'Unknown') then
      if battery_state <= 20 then
        batt_icon = wezterm.nerdfonts.md_battery_charging_low
      elseif battery_state > 20 and battery_state <= 50 then
        batt_icon = wezterm.nerdfonts.md_battery_charging_medium
      elseif battery_state > 50 and battery_state <= 80 then
        batt_icon = wezterm.nerdfonts.md_battery_charging_medium
      else
        batt_icon = wezterm.nerdfonts.md_battery_charging_100
      end
    elseif charging_state == 'Discharging' then
      if battery_state <= 20 then
        batt_icon = wezterm.nerdfonts.fa_battery_quarter
      elseif battery_state > 20 and battery_state <= 50 then
        batt_icon = wezterm.nerdfonts.fa_battery_half
      elseif battery_state > 50 and battery_state <= 75 then
        batt_icon = wezterm.nerdfonts.fa_battery_three_quarters
      else
        batt_icon = wezterm.nerdfonts.fa_battery_full
      end
    end


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
