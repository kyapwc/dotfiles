local noNeckPain = require('no-neck-pain')

noNeckPain.setup({
  buffers = {
    left = {
      enabled = false,
    },
    right = {
      colors = {
        background = "tokyonight-day",
      },
    },
    scratchPad = {
      -- set to `false` to
      -- disable auto-saving
      enabled = true,
      -- set to `nil` to default
      -- to current working directory
      location = "~/Documents/",
    },
    bo = {
      filetype = "md"
    },
    wo = {
      fillchars = "eob: ",
    },
  },
})
