local fn = vim.fn

-- Ensure packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end

  augroup presentation
    autocmd!

    " Presentation mode
    au FileType markdown nnoremap <buffer> <space>ps :PresentingStart<CR>
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = 'rounded' }
    end,
  },
}

-- Startup and add configured plugins
packer.startup(function(use)
  -- Plugin manager
  use 'wbthomason/packer.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end

  -- Treesitter and theme
  use { 'nvim-treesitter/nvim-treesitter' }
  use { 'nvim-treesitter/playground' }
  -- use { 'junegunn/seoul256.vim' }
  -- use { 'sainnhe/everforest' }
  use { 'folke/tokyonight.nvim' }
  -- use { 'tiagovla/tokyodark.nvim' }
  -- use { 'Rigellute/shades-of-purple.vim' }

  -- Git-related
  use 'tpope/vim-fugitive'

  -- Telescope.nvim
  use 'nvim-lua/plenary.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- FZF-related
  use { 'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use { 'junegunn/fzf', run = './install --bin', }
  use 'jremmen/vim-ripgrep'

  -- LuaLine (status Line)
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Vim -> TMUX navigation
  use 'alexghergh/nvim-tmux-navigation'

  -- Bufferline
  use {
    'akinsho/bufferline.nvim',
    tag = "v2.*",
    requires = 'kyazdani42/nvim-web-devicons'
  }

  -- AUTOPAIRING
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt" },
        map_c_w = true,
        map_cr = false,
      })
    end
  }

  -- NVIM Surround
  use {
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
  }

  -- MISC
  use 'lukas-reineke/indent-blankline.nvim'

  -- Native LSP setup
  -- use {
  --   "folke/which-key.nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require('yap.whichkey').setup()
  --   end,
  -- }

  use {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require "notify"
    end,
  }

  -- migrate from nvim-lsp-installer to mason
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }

  -- lspconfig - Language Server Protocol config
  use {
    'neovim/nvim-lspconfig',
    -- opt = true,
    event = 'BufEnter',
    wants = { 'coq_nvim', 'lsp_signature.nvim' },
    config = function()
      require('yap/config/lsp').setup()
    end,
    requires = {
      'ray-x/lsp_signature.nvim',
    },
  }

  use 'ray-x/lsp_signature.nvim'

  -- coq is better than coc
  use 'ms-jpq/coq_nvim'

  -- AutoTag for html <body>, etc tags
  use {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }

  -- SplitJoin to split and join long lists
  use 'AndrewRadev/splitjoin.vim'

  -- lastplace to save "sessions"
  use {
    'ethanholz/nvim-lastplace',
    config = function()
      require('nvim-lastplace').setup({
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_ignore_filetype = { 'gitcommit', 'gitrebase', 'svn', 'hgcommit' },
      })
    end,
  }

  -- Commenter
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  use 'lewis6991/gitsigns.nvim'

  use {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup()
    end
  }

  use 'sotte/presenting.vim'

  -- use 'rhysd/conflict-marker.vim'

  use {
    'SirVer/ultisnips',
    requires = { { 'honza/vim-snippets' } }
  }

  use { 'elihunter173/dirbuf.nvim' }

  use { 'fatih/vim-go' }

  use { 'liuchengxu/vista.vim' }

  use { 'numToStr/FTerm.nvim' }

  use { 'lewis6991/impatient.nvim' }

  use { 'zakharykaplan/nvim-retrail' }

  use {
    "ghillb/cybu.nvim",
    branch = "main",
    requires = { "kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim"},
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
  }

  use {
    'rrethy/vim-hexokinase',
    run = 'make hexokinase',
  }

  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        position = 'bottom',
        height = 20,
        icons = true,
        use_diagnostic_signs = true,
      })
    end,
  }

  use {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup({
        width = 120,
        height = 50,
      })
    end
  }

  use {
    'goolord/alpha-nvim',
    config = function ()
      require'alpha'.setup(require'alpha.themes.dashboard'.config)
    end
  }

  use { 'rust-lang/rust.vim' }

  use { 'simrat39/rust-tools.nvim' }

  use {
    'akinsho/flutter-tools.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('flutter-tools').setup({})
    end,
  }

  -- use {
  --   'glacambre/firenvim',
  --   run = function() vim.fn['firenvim#install'](0) end
  -- }

  use { 'folke/twilight.nvim' }

  use { 'nathom/filetype.nvim' }

  use {
    "gnikdroy/projections.nvim",
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
  }

  -- use { 'bennypowers/nvim-regexplainer',
  --   config = function() require'regexplainer'.setup() end,
  --   requires = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'MunifTanjim/nui.nvim',
  --   },
  -- }

  use { 'tamton-aquib/stuff.nvim' }

  use { 'adelarsq/vim-matchit' }

  use { 'rafcamlet/nvim-luapad' }

  -- use { 'kyapwc/gojira.nvim' }
  use { '~/workspace/gojira.nvim' }

  use { 'folke/neodev.nvim' }

  -- use { 'j-hui/fidget.nvim' }
  -- use {
  --   'folke/noice.nvim',
  --   requires = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
  -- }

end)
