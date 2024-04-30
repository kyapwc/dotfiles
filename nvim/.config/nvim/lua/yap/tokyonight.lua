local tokyonight = require('tokyonight')

tokyonight.setup({
  style = 'moon',
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = { italic = true },
  },
  on_colors = function(colors)
    colors.border = '#76365B'
  end,
})
