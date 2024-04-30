require('orgmode').setup_ts_grammar()

require('orgmode').setup({
  org_agenda_files = { '~/.config/nvim/notes/agendas/*' },
  org_default_notes_file = '~/.config/nvim/notes/refile.org',
})
