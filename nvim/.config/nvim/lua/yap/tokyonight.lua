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
  on_highlights = function(hl, c)
    -- keep it theme-relative, not hex
    hl.Pmenu      = { fg = c.fg, bg = c.bg_dark }
    hl.PmenuSel   = { fg = c.fg, bg = c.bg_highlight, bold = true }
    hl.PmenuSbar  = { bg = c.bg_dark }
    hl.PmenuThumb = { bg = c.bg_highlight }

    -- Add this for completion menu borders
    hl.CmpBorder  = { fg = '#bb9af7', bg = 'NONE' }
  end,
  cache = true
})
