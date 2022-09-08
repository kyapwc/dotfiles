local fn = vim.fn

-- Ensure packer is installed
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("Installing Packer, close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

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

  -- Treesitter and theme
  use { 'nvim-treesitter/nvim-treesitter' }
  use { 'junegunn/seoul256.vim' }
  use { 'sainnhe/everforest' }
  use { 'folke/tokyonight.nvim' }
  use { 'tiagovla/tokyodark.nvim' }
  use { 'Rigellute/shades-of-purple.vim' }

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
        delimiters = {
          pairs = {
            ["q"] = { "'", "'" },
            ["Q"] = { '"', '"' },
          },
          aliases = {
            ["q"] = { "'" },
            ["Q"] = { '"' },
          }
        },
        highlight_motion = {
          duration = 10,
        }
      })
    end
  }

  -- MISC
  use 'lukas-reineke/indent-blankline.nvim'

  -- Native LSP setup
  use {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require('yap.whichkey').setup()
    end,
  }

  use {
    "rcarriga/nvim-notify",
    event = "VimEnter",
    config = function()
      vim.notify = require "notify"
    end,
  }

  -- lspconfig - Language Server Protocol config
  use {
    'neovim/nvim-lspconfig',
    -- opt = true,
    event = 'BufEnter',
    wants = { 'nvim-lsp-installer', 'coq_nvim', 'lsp_signature.nvim' },
    config = function()
      require('yap/config/lsp').setup()
    end,
    requires = {
      'williamboman/nvim-lsp-installer',
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

  use 'rhysd/conflict-marker.vim'

  use {
    'SirVer/ultisnips',
    requires = { { 'honza/vim-snippets' } }
  }

  use { 'elihunter173/dirbuf.nvim' }

  use { 'fatih/vim-go' }

  use { 'liuchengxu/vista.vim' }

  use {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({})
    end
  }

  use { 'arkav/lualine-lsp-progress' }

  use { 'numToStr/FTerm.nvim' }

  use { 'lewis6991/impatient.nvim' }

  use { 'wfxr/minimap.vim' }

  use {
    'zakharykaplan/nvim-retrail',
    config = function()
      require('retrail').setup({})
    end
  }

  -- use { 'nvim-orgmode/orgmode' }

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
