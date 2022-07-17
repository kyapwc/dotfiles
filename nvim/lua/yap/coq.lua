vim.g.coq_settings = {
  auto_start = true,
  keymap = {
    jump_to_mark = 'null',
    eval_snips = 'null',
  },
}

local coq = require('coq')

vim.cmd('COQnow')
