local ls = require('luasnip')
local notify = require('notify')
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
local keymap = vim.keymap

keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true})

keymap.set({ "i", "s" }, "<C-l>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end, { silent = true })

keymap.set({ "i", "s" }, "<C-h>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-e>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

ls.config.set_config({
  history = true,
  updateevents = 'TextChanged',
  -- updateevents = 'TextChanged, TextChangedI',
  enable_autosnippets = false,
})

local same = function(index)
  return func(function(arg)
    return arg[1]
  end, { index })
end

local get_test_result = function(position)
  return dynamicn(position,
    function()
      local nodes = {}
      table.insert(nodes, text(''))

      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      for _, line in ipairs(lines) do
        if line:match('anyhow::Result') then
          table.insert(nodes, text(' -> Result<()> '))
          break;
        end
      end
      return node(nil, choice(1, nodes))
    end, {})
end

ls.add_snippets(nil, {
  all = {
    snip(
      'test',
      fmt(
        [[
          #[test]
          fn {}(){} {{
            {}
          }}
        ]], {
          insert(1, 'testname'),
          get_test_result(2),
          insert(0),
        }
      )
    ),
    snip(
      'uuid',
      fmt([[{}]], {
        func(function()
          local uuid = GenUUID()
          return uuid
        end)
      })
    ),
    snip(
      'date',
      func(function()
        return os.date "%D - %H:%M"
      end)
    ),
    snip(
      'sametest',
      fmt([[ example: {}, function: {} ]], { insert(1), same(1) })
    ),
  },

  lua = {
    -- snip('req', fmt('local {} = require(\'{}\')', { insert(1, 'default'), rep(1) })),
    snip(
      'req',
      fmt([[local {} = require('{}')]], {
        func(function(import_name)
          local parts = vim.split(import_name[1][1], '.', { plain = true })
          return parts[#parts] or ""
        end, { 1 }),
        insert(1),
      })
    )
  },

  javascript = {
    snip('cl', fmt([[console.log('{}')]], { insert(1, 'whats up?') })),
    snip('clog', fmt([[console.log('{}: ', {})]], { insert(1, 'variable'), rep(1) })),
    snip(
      'pt',
      fmt("PropTypes.{}{},", {
        choice(1, {
          text('func'),
          text('string'),
          text('number'),
          text('bool'),
        }),
        choice(2, {
          text('.isRequired'),
          text(''),
        })
      })
    ),
    snip(
      'todo',
      fmt([[
        // @TODO: at {}: {}
      ]], {
        func(function()
          return os.date "%D - %H:%M"
        end),
        insert(1),
      })
    ),
    snip(
      'react',
      fmt([[
        import React from 'react'

        const {} = () => {{
        }}

        export default {}
      ]], {
        insert(1),
        rep(1),
      })
    ),
  },

  typescript = {
    snip('cl', fmt([[console.log('{}');]], { insert(1, 'variable') })),
    snip('clog', fmt([[console.log('{}: ', {});]], { insert(1, 'variable'), rep(1) })),
    snip(
      'nestc',
      fmt([[
        import {{ Injectable }} from '@nestjs/common';

        @Injectable()
        export class {} {{
          {}
        }}
      ]], {
        insert(1, 'ClassName'),
        insert(2)
      })
    ),
    snip(
      'nestm',
      fmt([[
        import {{ Module }} from '@nestjs/common';

        @Module({{
          imports: [{2}],
          providers: [{3}],
          exports: [{4}],
        }})
        export class {1} {{}}
      ]], {
        insert(1, 'ModuleName'),
        insert(2),
        insert(3),
        insert(4),
      })
    ),
    snip(
      'nestt',
      fmt([[
        import {{ AppE2eTestHelper }} from 'src/test/test.helper';

        describe('{}', () => {{
          let testHelper: AppE2eTestHelper;
          let service: {};

          beforeAll(async () => {{
            testHelper = new AppE2eTestHelper();
            await testHelper.init([{}]);
            service = testHelper.app.get({})
          }});

          afterAll(async () => {{
            await testHelper.close();
          }});

          afterEach(async () => {{
            await testHelper.clearDatabase();
          }});

          it('{}', async () => {{
            {}
          }})
        }})
      ]], {
        insert(1, 'Describe Test Name'),
        insert(2, 'Service To Test'),
        insert(3, 'Module To init'),
        rep(2),
        insert(4, 'What should it do?'),
        insert(5),
      })
    ),
    snip(
      'todo',
      fmt([[
        // @TODO: at {}: {}
      ]], {
        func(function()
          return os.date "%D - %H:%M"
        end),
        insert(2),
      })
    )
  },

  typescriptreact = {
    snip('cl', fmt([[console.log('{}');]], { insert(1, 'variable') })),
    snip('clog', fmt([[console.log('{}: ', {});]], { insert(1, 'variable'), rep(1) })),
    snip(
      'nestc',
      fmt([[
        import {{ Injectable }} from '@nestjs/common';

        @Injectable()
        export class {} {{
          {}
        }}
      ]], {
        insert(1, 'ClassName'),
        insert(2)
      })
    ),
    snip(
      'nestm',
      fmt([[
        import {{ Module }} from '@nestjs/common';

        @Module({{
          imports: [{2}],
          providers: [{3}],
          exports: [{4}],
        }})
        export class {1} {{}}
      ]], {
        insert(1, 'ModuleName'),
        insert(2),
        insert(3),
        insert(4),
      })
    ),
    snip(
      'nestt',
      fmt([[
        import {{ AppE2eTestHelper }} from 'src/test/test.helper';

        describe('{}', () => {{
          let testHelper: AppE2eTestHelper;
          let service: {};

          beforeAll(async () => {{
            testHelper = new AppE2eTestHelper();
            await testHelper.init([{}]);
            service = testHelper.app.get({})
          }});

          afterAll(async () => {{
            await testHelper.close();
          }});

          afterEach(async () => {{
            await testHelper.clearDatabase();
          }});

          it('{}', async () => {{
            {}
          }})
        }})
      ]], {
        insert(1, 'Describe Test Name'),
        insert(2, 'Service To Test'),
        insert(3, 'Module To init'),
        rep(2),
        insert(4, 'What should it do?'),
        insert(5),
      })
    ),
    snip(
      'todo',
      fmt([[
        // @TODO: at {}: {}
      ]], {
        func(function()
          return os.date "%D - %H:%M"
        end),
        insert(2),
      })
    ),
    snip(
      'fc',
      fmt([[
        import {{ FC }} from 'react';

        interface {}Props {{
          {}
        }}

        const {}: FC<{}Props> = () => {{
          return <div>{}</div>;
        }}

        export default {};
      ]], {
        rep(1),
        insert(2),
        insert(1, 'ComponentName'),
        rep(1),
        rep(1),
        rep(1),
      })
    )
  },

  tsx = {
    snip('cl', fmt([[console.log('{}');]], { insert(1, 'variable') })),
    snip('clog', fmt([[console.log('{}: ', {});]], { insert(1, 'variable'), rep(1) })),
    snip(
      'nestc',
      fmt([[
        import {{ Injectable }} from '@nestjs/common';

        @Injectable()
        export class {} {{
          {}
        }}
      ]], {
        insert(1, 'ClassName'),
        insert(2)
      })
    ),
    snip(
      'nestm',
      fmt([[
        import {{ Module }} from '@nestjs/common';

        @Module({{
          imports: [{2}],
          providers: [{3}],
          exports: [{4}],
        }})
        export class {1} {{}}
      ]], {
        insert(1, 'ModuleName'),
        insert(2),
        insert(3),
        insert(4),
      })
    ),
    snip(
      'nestt',
      fmt([[
        import {{ AppE2eTestHelper }} from 'src/test/test.helper';

        describe('{}', () => {{
          let testHelper: AppE2eTestHelper;
          let service: {};

          beforeAll(async () => {{
            testHelper = new AppE2eTestHelper();
            await testHelper.init([{}]);
            service = testHelper.app.get({})
          }});

          afterAll(async () => {{
            await testHelper.close();
          }});

          afterEach(async () => {{
            await testHelper.clearDatabase();
          }});

          it('{}', async () => {{
            {}
          }})
        }})
      ]], {
        insert(1, 'Describe Test Name'),
        insert(2, 'Service To Test'),
        insert(3, 'Module To init'),
        rep(2),
        insert(4, 'What should it do?'),
        insert(5),
      })
    ),
    snip(
      'todo',
      fmt([[
        // @TODO: at {}: {}
      ]], {
        func(function()
          return os.date "%D - %H:%M"
        end),
        insert(2),
      })
    )
  },

  go = {
    snip(
      'clog',
      fmt([[fmt.Printf("{} %+v\n", {})]], {
          insert(1, 'prefix?'),
          insert(2, 'variable'),
      })
    ),
  },

  html = {
    snip(
      'todo',
      fmt([[
         <!-- @TODO: at {}: {} -->
      ]], {
        func(function()
          return os.date "%D - %H:%M"
        end),
        insert(1),
      })
    )
  },

  ejs = {
    snip(
      'todo',
      fmt([[
         <!-- @TODO: at {}: {} -->
      ]], {
        func(function()
          return os.date "%D - %H:%M"
        end),
        insert(1),
      })
    )
  },
})

keymap.set('n', '<leader>sl', '<cmd>source ~/.config/nvim/lua/yap/luasnip.lua<CR>')
