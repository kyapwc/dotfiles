local neotest = require('neotest')
local neotest_jest = require('neotest-jest')

neotest.setup({
  adapters = {
    neotest_jest({
      cwd = function(path)
        return vim.fn.getcwd()
      end
    })
  }
})
