require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = { left = '|', right = '|' },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  }
})
