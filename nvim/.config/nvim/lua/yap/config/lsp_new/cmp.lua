local lspkind = require('lspkind')

lspkind.init({ symbol_map = { Supermaven = "" } })

local cmp = require('cmp')
local luasnip = require('luasnip')
local signature = require('lsp_signature')

signature.setup({
  hint_enable = false,
  handler_opts = { border = "single" },
  max_width = 80,
})

vim.o.pumheight = 15

local vim_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg == 'No information available' then
    return
  end

  return vim_notify(msg, level, opts)
  -- Or with `rcarriga/nvim-notify`
  -- return require('notify').notify(msg, level, opts)
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    -- completion = {
    --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    --   col_offset = -3,
    --   side_padding = 0,
    -- },
    documentation = cmp.config.window.bordered(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = "buffer" },
    { name = "path" },
    { name = "supermaven" },
    -- { name = "nvim_lsp_signature_help" },
    {
      name = "omni",
      option = {
        disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' }
      }
    },
    { name = "copilot", group_index = 2 },
    { name = "npm" },
  }, { name = 'buffer' }),
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4),  -- Down
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-Space>'] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  formatting = {
    fields = { "abbr", "kind", "menu", "kind" },
    format = function(entry, vim_item)
      local menu_icon = {
        nvim_lsp = 'λ',
        vsnip = '⋗',
        buffer = 'Ω',
        path = '~',
        Supermaven = ""
      }
      local function commom_format(e, item)
        local kind = require("lspkind").cmp_format({
          mode = "symbol_text",
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        })(e, item)
        kind.menu = menu_icon[e.source.name] or ''
        kind.concat = kind.abbr
        return kind
      end
      return commom_format(entry, vim_item)
    end,
  }
})

-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg = 'NONE', strikethrough = true, fg = '#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg = 'NONE', fg = '#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg = 'NONE', fg = '#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link = 'CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link = 'CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg = 'NONE', fg = '#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link = 'CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg = 'NONE', fg = '#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link = 'CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link = 'CmpItemKindKeyword' })
