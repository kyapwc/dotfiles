local configs = require('nvim-treesitter.configs')

configs.setup {
  highlight = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  autotag = {
    enable = true,
  },
  ensure_installed = {
    'javascript',
    'typescript',
    'go',
    'python',
    'gdscript',
    'css',
    'dart',
    'json',
    'html',
    'jsdoc',
    'bash',
    'proto',
    'vim',
  }
}
