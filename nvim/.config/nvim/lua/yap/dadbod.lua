-- local dadbod = require('vim-dadbod')

vim.cmd [[
autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
]]
