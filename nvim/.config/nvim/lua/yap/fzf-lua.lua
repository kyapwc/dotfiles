local actions = require('fzf-lua.actions')

require('fzf-lua').setup({
  lsp = {
    code_actions = {
      previewer = 'codeaction_native',
      preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
    },
  },
  file_ignore_patterns = { "undodir$", "dist" },
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
    height = 0.4,
    width = 1.0,
    row = 1.0,
    -- row = 0.5,
    border = 'rounded',
    preview = {
      layout = 'horizontal',
      foldenable = true,
      signcolumn = "yes",
    },
  },
  actions = {
    files = {
      -- ['default'] = actions.file_edit,
      ['default'] = actions.file_edit_or_qf,
      ['ctrl-v'] = actions.file_vsplit,
    }
  },
  keymap = {
    builtin = {
      ["<C-u>"] = 'preview-page-up',
      ["<C-d>"] = 'preview-page-down',
    },
  },
  oldfiles = {
    prompt = "History❯ ",
    cwd_only = true,
  }
})
