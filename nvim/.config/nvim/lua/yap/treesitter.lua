local configs = require('nvim-treesitter.configs')

configs.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  ignore_install = { "help" },
  indent = {
    enable = true,
    disable = { "go", "python", "help" },
  },
  -- incremental_selection = { enable = true },
  textobjects = { enable = true },
  -- autotag = { enable = true },
  ensure_installed = {
    -- 'org',
    'javascript',
    'typescript',
    'tsx',
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
    'rust',
    'help',
    'regex',
    'embedded_template',
    'http',
    'json',
    'markdown',
    'markdown_inline',
    'vimdoc',
    'luadoc',
    'lua',
    'c',
    'c_sharp',
    'dockerfile'
  },
  playground = {
    enable = true,
    updatetime = 25,
    persist_queries = false,
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
}

-- Set comment color to identifier for tree-sitter for easier visibility
vim.api.nvim_set_hl(0, 'Comment', { link = 'Identifier' })
