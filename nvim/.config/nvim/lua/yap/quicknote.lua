local quicknote = require('quicknote')

quicknote.setup({
  sign = "󱝽",
  filetype = "md",
  git_branch_recognizable = false,
  mode = 'resident',
})
quicknote.ShowNoteSigns()

-- =======================
-- KeyBinds
-- =======================
vim.keymap.set(
  'n',
  '<LEADER>cn',
  function()
    quicknote.NewNoteAtCurrentLine()
  end,
  { noremap = true, silent = true, desc = 'Create Note at Current Line' }
)

vim.keymap.set(
  'n',
  '<LEADER>dn',
  function()
    quicknote.DeleteNoteAtCurrentLine()
  end,
  { noremap = true, silent = true, desc = 'Delete Note at Current Line' }
)

vim.keymap.set(
  'n',
  '<LEADER>vn',
  function()
    quicknote.OpenNoteAtCurrentLine()
  end,
  { noremap = true, silent = true, desc = 'Open Note at Current Line' }
)

vim.keymap.set(
  'n',
  '<LEADER>ns',
  function()
    quicknote.ToggleNoteSigns()
  end,
  { noremap = true, silent = true, desc = "Toggle Note Signs" }
)

vim.keymap.set(
  'n',
  '<LEADER>nn',
  function()
    quicknote.JumpToNextNote()
  end,
  { noremap = true, silent = true, desc = "Toggle Note Signs" }
)

vim.keymap.set(
  'n',
  '<LEADER>lsc',
  function()
    quicknote.ListNotesForCurrentBuffer()
  end,
  { noremap = true, silent = true, desc = "Toggle Note Signs" }
)

vim.keymap.set(
  'n',
  '<LEADER>lsg',
  function()
    quicknote.ListNotesForGlobal()
  end,
  { noremap = true, silent = true, desc = "Toggle Note Signs" }
)
