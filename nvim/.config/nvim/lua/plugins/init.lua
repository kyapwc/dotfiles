return {
  -- Treesitter and theme
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-treesitter/playground' },
  -- { 'junegunn/seoul256.vim' },
  -- { 'sainnhe/everforest' },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  -- { 'tiagovla/tokyodark.nvim' },
  -- { 'Rigellute/shades-of-purple.vim' },
  {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'macchiato',
        background = {
          light = 'macchiato',
          dark = 'macchiato',
        },
        term_colors = true,
        show_end_of_buffer = false,
        dim_inactive = {
          enabled = true,
          shade = 'dark',
          percentage = 0.15,
        },
        custom_highlight = {
          Comment = { style = { "italic" } },
          ['@comment'] = { style = { "italic" } },
        },
      })
    end
  },

  -- Git-related
  'tpope/vim-fugitive',

  -- Telescope.nvim
  'nvim-lua/plenary.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },

  -- FZF-related
  { 'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  { 'junegunn/fzf', build = './install --bin', },
  'jremmen/vim-ripgrep',

  -- LuaLine (status Line)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    -- version = "*", -- disable version for v0.10.0 nvim
    dependencies = 'nvim-tree/nvim-web-devicons',
  },

  -- AUTOPAIRING
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt" },
        map_c_w = true,
        map_cr = false,
      })
    end
  },

  -- NVIM Surround
  {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({
        surronds = {
          pairs = {
            ["q"] = { "'", "'" },
            ["Q"] = { '"', '"' },
          },
          aliases = {
            ["q"] = { "'" },
            ["Q"] = { '"' },
          }
        },
        highlight = {
          duration = 10,
        }
      })
    end
  },

  -- MISC
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts= {} },

  -- Native LSP setup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

  {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require "notify"
      require('notify').setup({
        -- level = vim.log.levels.WARN,
        -- timeout = 2000,
        -- max_width = 100,
        max_height = 5,
        stages = 'static',
        background_colour = '#FFFFFF',
      })
    end,
  },

  -- migrate from nvim-lsp-installer to mason
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- lspconfig - Language Server Protocol config
  {
    'neovim/nvim-lspconfig',
    -- opt = true,
    event = 'BufEnter',
    wants = { 'coq_nvim', 'lsp_signature.nvim' },
    config = function()
      require('yap/config/lsp').setup()
    end,
    dependencies = {
      'ray-x/lsp_signature.nvim',
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
      }
    },
  },

  'ray-x/lsp_signature.nvim',

  -- coq is better than coc
  'ms-jpq/coq_nvim',

  -- AutoTag for html <body>, etc tags
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- SplitJoin to split and join long lists
  'AndrewRadev/splitjoin.vim',

  -- lastplace to save "sessions"
  {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup({
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
      })
    end,
  },

  -- Commenter
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  'lewis6991/gitsigns.nvim',

  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup({
        builtin_marks = { "<", ">", "^", ";", "'" },
      })
    end
  },

  'sotte/presenting.vim',

  { 'fatih/vim-go' },

  -- { 'liuchengxu/vista.vim' },

  { 'numToStr/FTerm.nvim' },

  { 'lewis6991/impatient.nvim' },

  { 'zakharykaplan/nvim-retrail' },

  {
    "ghillb/cybu.nvim",
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim"},
    config = function()
      local ok, cybu = pcall(require, "cybu")
      if not ok then
        return
      end
      cybu.setup()
      -- vim.keymap.set("n", "K", "<Plug>(CybuPrev)")
      -- vim.keymap.set("n", "J", "<Plug>(CybuNext)")
      vim.keymap.set({"n", "v"}, "<s-Tab>", "<Plug>(CybuPrev)")
      vim.keymap.set({"n", "v"}, "<Tab>", "<Plug>(CybuNext)")
    end,
  },

  {
    'rrethy/vim-hexokinase',
    build = 'make hexokinase',
  },

  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        position = 'bottom',
        height = 20,
        icons = true,
        use_diagnostic_signs = true,
      })
    end,
  },

  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup({
        width = 120,
        height = 50,
      })
    end
  },

  {
    'goolord/alpha-nvim',
    config = function ()
      require'alpha'.setup(require'alpha.themes.startify'.config)
    end
  },

  { 'rust-lang/rust.vim' },

  { 'simrat39/rust-tools.nvim' },

  {
    'akinsho/flutter-tools.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('flutter-tools').setup({})
    end,
  },

  -- {
  --   'glacambre/firenvim',
  --   build = function() vim.fn['firenvim#install'](0) end
  -- },

  { 'folke/twilight.nvim' },

  -- { 'nathom/filetype.nvim' },

  {
    "gnikdroy/projections.nvim",
    branch = "pre_release",
    config = function()
      require("projections").setup({
        workspaces = {
          { "~/go/src/bitbucket.org/pick-up/pickupp/packages", {} },
          { "~/go/src/bitbucket.org/pick-up/pickupp/apps", {} },
          { "~/go/src/bitbucket.org/pick-up/pickupp/shared", {} },
          -- { "~/go/src/bitbucket.org/pick-up/pickupp", { ".git" } },
          patterns = { ".git" },
        }
      })

      -- Bind <leader>fp to Telescope projections
      require('telescope').load_extension('projections')
      vim.keymap.set("n", "<leader>fp", function() vim.cmd("Telescope projections") end)

      -- Autostore session on DirChange and VimExit
      -- local Session = require("projections.session")
      -- vim.api.nvim_create_autocmd({ 'DirChangedPre', 'VimLeavePre' }, {
      --   callback = function() Session.store(vim.loop.cwd()) end,
      -- })
    end
  },

  -- { 'bennypowers/nvim-regexplainer',
  --   config = function() require'regexplainer'.setup() end,
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'MunifTanjim/nui.nvim',
  --   },
  -- },

  { 'tamton-aquib/stuff.nvim' },

  { 'adelarsq/vim-matchit' },

  { 'rafcamlet/nvim-luapad' },

  -- { 'kyapwc/gojira.nvim' },
  -- {
  --   dir = '/Users/kenyap/workspace/gojira.nvim',
  -- },

  { 'folke/neodev.nvim' },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
    config = function()
      require('fidget').setup({})
    end
  },
  { 'mhartington/formatter.nvim' },

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },

  -- {
  --   'stevearc/dressing.nvim',
  --   opts = {},
  -- },

  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = true,
  },

  -- {
  --   'rest-nvim/rest.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  -- },

  { 'mrjones2014/smart-splits.nvim' },

  -- {
  --   "nvim-neorg/neorg",
  --   build = ":Neorg sync-parsers",
  --   lazy = false, -- specify lazy = false because some lazy.nvim distributions set lazy = true by default
  --   -- tag = "*",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require("neorg").setup {
  --       load = {
  --         ["core.defaults"] = {}, -- Loads default behaviour
  --         ["core.concealer"] = {}, -- Adds pretty icons to your documents
  --         ["core.dirman"] = { -- Manages Neorg workspaces
  --           config = {
  --             workspaces = {
  --               notes = "~/notes",
  --             },
  --             default_workspace = "notes"
  --           },
  --         },
  --       },
  --     }
  --   end,
  -- },

  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     -- "rcarriga/nvim-notify",
  --   }
  -- },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require('peek').setup({})
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        dir_path = function()
          return vim.fn.expand('$HOME/tmp')
        end,
      }
    },
    keys = {
      -- suggested keymap
      { "<M-p>", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },

  {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  },

  {
    "RutaTang/quicknote.nvim",
    dependencies = { "nvim-lua/plenary.nvim"}
  },

  { "backdround/global-note.nvim" },

  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh",
    config = function()
      require('sniprun').setup({
        display = {
          "TerminalWithCode",
        },
      })
    end
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      require('illuminate').configure({})
    end,
  },
}
