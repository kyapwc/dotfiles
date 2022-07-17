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
  use 'nvim-treesitter/nvim-treesitter'
  use 'junegunn/seoul256.vim'
  use 'sainnhe/everforest'

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

  -- CHADTREE
  use {
    'ms-jpq/chadtree',
    run = 'python3 -m chadtree deps'
  }

  -- AUTOPAIRING
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt" },
        map_c_w = true,
        map_cr = true,
      })
    end
  }

  -- NVIM Surround
  use {
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup({
        aliases = {
          ["q"] = { "'", '"', '`' },
        },
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

  use {
    'neovim/nvim-lspconfig',
    opt = true,
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

  use { 'ms-jpq/coq_nvim' }

  use {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }

  use 'AndrewRadev/splitjoin.vim'

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
