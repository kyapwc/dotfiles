local actions = require('fzf-lua.actions')

require('fzf-lua').setup({
  file_ignore_patterns = { "undodir$" },
  previewers = {
    builtin = {
      extensions = {
        ["png"] = { "viu", "-b" },
        ["jpg"] = { "viu", "-b" },
      },
    },
  },
  fzf_opts = {
    ['--layout'] = 'reverse-list',
  },
  winopts = {
    height = 0.3,
    width = 1.0,
    row = 1.0,
    border = 'rounded',
    preview = {
      layout = 'horizontal',
      foldenable = true,
      signcolumn = "yes",
    },
  },
  actions = {
    files = {
      ["default"] = actions.file_edit
    }
  },
})
