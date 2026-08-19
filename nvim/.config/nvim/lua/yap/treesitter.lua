local configs = require('nvim-treesitter.configs')

local ensure_installed = {
  'javascript',
  'typescript',
  'tsx',
  'python',
  'css',
  'dart',
  'json',
  'html',
  'jsdoc',
  'bash',
  'proto',
  'vim',
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
  'dockerfile'
}

if not IS_DEVCONTAINER() then
  local host_only = {
    'go',
    'c',
    'c_sharp',
    'gdscript',
    'rust',
  }
  vim.list_extend(ensure_installed, host_only)
end

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
  ensure_installed = ensure_installed,
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

-- Work around a nvim-treesitter bug rather than patching the vendored plugin
-- (which `:Lazy update` would just wipe out again): as of Nvim 0.12, a query
-- match hands directives a LIST per capture (e.g. `{ [1] = <TSNode> }`)
-- instead of a bare TSNode, even though nvim-treesitter's legacy
-- compatibility shim requests `all = false` (which is supposed to mean "give
-- me a single node"). nvim-treesitter's `set-lang-from-info-string!`
-- directive (markdown/query_predicates.lua) assumes a bare node and crashes
-- when it gets the list instead, which silently breaks language detection
-- for fenced code blocks in markdown -- most visibly, LSP hover popups
-- render code snippets as flat, unhighlighted text because the injected
-- language never gets set.
--
-- Force-register a corrected version of that directive here. This runs
-- after nvim-treesitter's own registration (forced by the `require` below)
-- and overrides it via `force = true`, so it survives plugin updates since
-- it lives in our own tracked config, not the plugin's vendored files.
require('nvim-treesitter.query_predicates')

local function unwrap_ts_node(node)
  if type(node) == 'table' then
    return node[1]
  end
  return node
end

local non_filetype_match_injection_language_aliases = {
  ex = 'elixir',
  pl = 'perl',
  sh = 'bash',
  uxn = 'uxntal',
  ts = 'typescript',
}

local function get_parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match({ filename = 'a.' .. injection_alias })
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

require('vim.treesitter.query').add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
  local node = unwrap_ts_node(match[pred[2]])
  if not node then
    return
  end
  local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata['injection.language'] = get_parser_from_markdown_info_string(injection_alias)
end, { force = true, all = false })

-- Same Nvim 0.12 list-wrapped-node issue as above, but hitting `kind-eq?`
-- (and its auto-derived `not-kind-eq?` negation) instead. This predicate is
-- used throughout queries/ecma/indents.scm -- inherited by javascript,
-- typescript and tsx -- to decide @indent.begin/@indent.dedent for ordinary
-- constructs like if-blocks and arrow functions. Unpatched, calling
-- `node:type()` on the list throws on nearly every `o`/`O`/`=` in JS/TS
-- files; Vim's indentexpr silently swallows that error and falls back to
-- indent level 0, which is why new lines were landing at column 0 instead
-- of matching the surrounding code.
require('vim.treesitter.query').add_predicate('kind-eq?', function(match, _pattern, _bufnr, pred)
  local node = unwrap_ts_node(match[pred[2]])
  if not node then
    return true
  end
  local types = { unpack(pred, 3) }
  return vim.tbl_contains(types, node:type())
end, { force = true, all = false })
