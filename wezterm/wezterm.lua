local wezterm = require 'wezterm'
local act = wezterm.action
local custom_keys = require('custom/keys')

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
  },
  cursor_bg = '#FF3131',
  cursor_border = '#FF3131',
  split = '#ff92d0',

  quick_select_label_bg = { Color = 'peru' },
  quick_select_label_fg = { Color = '#ffffff' },
  quick_select_match_bg = { AnsiColor = 'Navy' },
  quick_select_match_fg = { Color = '#ffffff' },
}
config.status_update_interval = 500

-- Colorschemeas and font
config.color_scheme = 'Tokyo Night'
config.font = wezterm.font_with_fallback({
  {
    family = 'Monaspace Radon',
    weight = 'ExtraBold',
    harfbuzz_features = { 'liga=1' },
    scale = 1,
  },
})
config.font_size = 10.5
config.audible_bell = 'Disabled'
config.adjust_window_size_when_changing_font_size = false

-- config.font = wezterm.font_with_fallback({
--   {
--     family = 'FiraCode Nerd Font Propo',
--     weight = 'Bold',
--     harfbuzz_features = { 'liga=1' },
--     scale = 0.9,
--   },
-- })

-- Settings
config.window_decorations = 'RESIZE'
-- config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 5,
  right = 5,
  top = 1,
  bottom = 1,
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
config.keys = custom_keys

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

config.quick_select_patterns = {
  '[0-9a-f]{7,40}',
}

config.unix_domains = {
  { name = 'unix' }
}

require('custom/right-status')

return config
