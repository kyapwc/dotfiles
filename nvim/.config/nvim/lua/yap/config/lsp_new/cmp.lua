local lspkind = require('lspkind')

lspkind.init({ symbol_map = { Supermaven = "" } })

local cmp = require('cmp')
local luasnip = require('luasnip')
local signature = require('lsp_signature')

local menu_icon = {
  nvim_lsp   = "λ [LSP]",
  vsnip      = "⋗ [VSnip]",
  buffer     = "Ω [Buffer]",
  path       = "~ [Path]",
  Supermaven = " [Supermaven]",
}

local function common_format(entry, item)
  local orig_kind = item.kind -- e.g. "Function", "Variable", etc.

  local formatted = require("lspkind").cmp_format({
    mode = "symbol_text",
    show_labelDetails = true,
  })(entry, item)

  -- Keep your kind highlight groups working even if you later change formatted.kind text
  formatted.kind_hl_group = "CmpItemKind" .. orig_kind

  -- Source label on the right
  formatted.menu = menu_icon[entry.source.name] or ""

  formatted.concat = formatted.abbr

  item.abbr = ' ' .. item.abbr
  item.menu = (item.menu or '') .. ' '

  return formatted
end

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
    -- completion = {
    --   winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
    --   col_offset = -3,
    --   side_padding = 0,
    -- },
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
    completion = cmp.config.window.bordered({
      winhighlight = "Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None"
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,Search:None",
    }),
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
    ['<C-m>'] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = common_format
  }
})

-- vim.cmd "highlight! BorderBG guibg=NONE guifg=#00ff00"
vim.cmd [[
  highlight! link CmpBorder Pmenu
  highlight! CmpBorder guifg=#bb9af7 guibg=NONE
]]
