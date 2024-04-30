local dressing = require('dressing')

dressing.setup({
  input = {
    enabled = true,
    default_prompt = 'Input: ',
    title_pos = 'center',
    border = 'rounded',
    relative = 'win',
    insert_only = true,
    start_in_insert = true,
  }
})
