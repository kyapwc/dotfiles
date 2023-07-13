return {
  -- Treesitter and theme
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-treesitter/playground' },
  -- { 'junegunn/seoul256.vim' },
  -- { 'sainnhe/everforest' },
  { 'folke/tokyonight.nvim' },
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
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },
  { 'junegunn/fzf', build = './install --bin', },
  'jremmen/vim-ripgrep',

  -- LuaLine (status Line)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
  },

  -- Vim -> TMUX navigation
  'alexghergh/nvim-tmux-navigation',

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    branch = "v2.*",
    dependencies = 'kyazdani42/nvim-web-devicons'
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
  'lukas-reineke/indent-blankline.nvim',

  -- Native LSP setup
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require('yap.whichkey').setup()
    end,
  },

  {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require "notify"
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
      require('marks').setup()
    end
  },

  'sotte/presenting.vim',

  -- 'rhysd/conflict-marker.vim',

  {
    'SirVer/ultisnips',
    dependencies = { { 'honza/vim-snippets' } }
  },

  { 'elihunter173/dirbuf.nvim' },

  { 'fatih/vim-go' },

  { 'liuchengxu/vista.vim' },

  { 'numToStr/FTerm.nvim' },

  { 'lewis6991/impatient.nvim' },

  { 'zakharykaplan/nvim-retrail' },

  {
    "ghillb/cybu.nvim",
    branch = "main",
    dependencies = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim"},
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

  { 'nathom/filetype.nvim' },

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
  -- { '~/workspace/gojira.nvim' },

  { 'folke/neodev.nvim' },

  -- { 'j-hui/fidget.nvim' },
  -- {
  --   'folke/noice.nvim',
  --   dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
  -- },
}
