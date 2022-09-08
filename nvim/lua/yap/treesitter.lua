local configs = require('nvim-treesitter.configs')

configs.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = { "go", "python" },
  },
  -- incremental_selection = { enable = true },
  textobjects = { enable = true },
  autotag = { enable = true },
  ensure_installed = {
    -- 'org',
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
  },
}
