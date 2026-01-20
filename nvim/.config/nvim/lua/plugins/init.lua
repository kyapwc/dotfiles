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
  -- {
  --   'catppuccin/nvim',
  --   as = 'catppuccin',
  --   config = function()
  --     require('catppuccin').setup({
  --       flavour = 'macchiato',
  --       background = {
  --         light = 'macchiato',
  --         dark = 'macchiato',
  --       },
  --       term_colors = true,
  --       show_end_of_buffer = false,
  --       dim_inactive = {
  --         enabled = true,
  --         shade = 'dark',
  --         percentage = 0.15,
  --       },
  --       custom_highlight = {
  --         Comment = { style = { "italic" } },
  --         ['@comment'] = { style = { "italic" } },
  --       },
  --     })
  --   end
  -- },

  -- Git-related
  'tpope/vim-fugitive',

  -- Telescope.nvim
  'nvim-lua/plenary.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-github.nvim' },
    }
  },

  -- FZF-related
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  { 'junegunn/fzf',                        build = './install --bin', },
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
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl',              opts = {} },

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
    event = 'BufEnter',
    wants = { 'coq_nvim', 'lsp_signature.nvim' },
    -- config = function()
    --   require('yap/config/lsp').setup()
    -- end,
    dependencies = {
      'ray-x/lsp_signature.nvim',
      'SmiteshP/nvim-navic',
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

  -- { 'fatih/vim-go' },

  { 'lewis6991/impatient.nvim' },

  { 'zakharykaplan/nvim-retrail' },

  {
    "ghillb/cybu.nvim",
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = function()
      local ok, cybu = pcall(require, "cybu")
      if not ok then
        return
      end
      cybu.setup()
      -- vim.keymap.set("n", "K", "<Plug>(CybuPrev)")
      -- vim.keymap.set("n", "J", "<Plug>(CybuNext)")
      vim.keymap.set({ "n", "v" }, "<s-Tab>", "<Plug>(CybuPrev)")
      vim.keymap.set({ "n", "v" }, "<Tab>", "<Plug>(CybuNext)")
    end,
  },

  {
    'rrethy/vim-hexokinase',
    build = 'make hexokinase',
  },

  {
    'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tT",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    'rmagatti/goto-preview',
    event = "BufEnter",
    config = true,
  },

  {
    'goolord/alpha-nvim',
    config = function()
      require 'alpha'.setup(require 'alpha.themes.startify'.config)
    end
  },

  { 'folke/twilight.nvim' },

  {
    "gnikdroy/projections.nvim",
    branch = "pre_release",
    config = function()
      require("projections").setup({
        workspaces = {
          -- { "~/go/src/bitbucket.org/pick-up/pickupp/packages", {} },
          -- { "~/go/src/bitbucket.org/pick-up/pickupp/apps", {} },
          -- { "~/go/src/bitbucket.org/pick-up/pickupp/shared", {} },
          -- { "~/go/src/bitbucket.org/pick-up/pickupp", { ".git" } },
          { "~/respond.io/respond-io/service", {} },
          patterns = { ".git" },
        }
      })

      -- Bind <leader>fp to Telescope projections
      require('telescope').load_extension('projections')
      vim.keymap.set("n", "<leader>fp", function() vim.cmd("Telescope projections") end)

      -- Autostore session on DirChange and VimExit
      local Session = require("projections.session")
      vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
        callback = function() Session.store(vim.loop.cwd()) end,
      })


      local switcher = require("projections.switcher")
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
          if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
        end,
      })
      vim.opt.sessionoptions:append("localoptions")
    end
  },

  { 'adelarsq/vim-matchit' },

  -- { 'kyapwc/gojira.nvim' },
  -- {
  --   dir = '/Users/kenyap/workspace/gojira.nvim',
  -- },

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

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp"
  },

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

  { 'mrjones2014/smart-splits.nvim' },

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

  {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },

  { "github/copilot.vim" },

  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       keymaps = {
  --         accept_suggestion = "<Tab>",
  --       },
  --       log_level = "off",
  --     })
  --   end,
  -- },

  {
    "ldelossa/gh.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup()
        end,
      },
    },
    config = function()
      require("litee.gh").setup()
    end,
  },

  { "MunifTanjim/nui.nvim" },

  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  {
    "David-Kunz/cmp-npm",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "json",
    config = function()
    end
  },

  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" }
  },

  {
    'stevearc/conform.nvim',
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "williamboman/mason.nvim",
    dependencies = {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local mason = require("mason")
      local mason_tool_installer = require("mason-tool-installer")

      -- enable mason and configure icons
      mason.setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      mason_tool_installer.setup({
        ensure_installed = {
          "prettier",
          "prettierd",
          "ktlint",
          "eslint",
          "eslint_d",
          "google-java-format",
          "htmlbeautifier",
          "beautysh",
          "buf",
          "rustfmt",
          "yamlfix",
          "taplo",
          "shellcheck",
          "gopls",
          -- { "gopls", version = "v0.14.2" },
          "delve",
          'lua-language-server',
          'vim-language-server',
          'luacheck',
          "codelldb",
        },
      })
    end,
  },

  -- {
  --   'pieces-app/plugin_neo_vim',
  --   config = function()
  --     require('pieces.config').host = 'http://localhost:1000'
  --   end,
  -- },

  { "akinsho/toggleterm.nvim" },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest"
    }
  },

  {
    "amitds1997/remote-nvim.nvim",
    version = "*",                     -- Pin to GitHub releases
    dependencies = {
      "nvim-lua/plenary.nvim",         -- For standard functions
      "MunifTanjim/nui.nvim",          -- To build the plugin UI
      "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
    },
    config = function()
      require("remote-nvim").setup({
        client_callback = function(port, workspace_config)
          local cmd = ("neovide --server localhost:%s"):format(
            port
          )
          vim.fn.jobstart(cmd, {
            detach = true,
            on_exit = function(job_id, exit_code, event_type)
              print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
            end,
          })
          -- Gracefully replace cur
          -- local cmd = ("wezterm cli set-tab-title --pane-id $(wezterm cli spawn nvim --server localhost:%s --remote-ui) %s")
          --     :format(
          --       port,
          --       ("'Remote: %s'"):format(workspace_config.host)
          --     )
          -- if vim.env.TERM == "xterm-kitty" then
          --   cmd = ("kitty -e nvim --server localhost:%s --remote-ui"):format(port)
          -- end
          -- vim.fn.jobstart(cmd, {
          --   detach = true,
          --   on_exit = function(job_id, exit_code, event_type)
          --     -- This function will be called when the job exits
          --     print("Client", job_id, "exited with code", exit_code, "Event type:", event_type)
          --   end,
          -- })
        end,
        devpod = {
          -- dotfiles = { },
          container_list = "running_only",
        },
        offline_mode = {
          enabled = true,
          no_github = false,
        }
      })
    end,
  },

  {
    'yousefakbar/notmuch.nvim',
    config = function()
      -- Configuration goes here
      local opts = {
        open_cmd = 'open',
      }
      require('notmuch').setup(opts)
    end,
  },

  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
      }
    },
    keys = {
      { "<F1>",     function() require('dap').continue() end },
      { "<F2>",     function() require('dap').toggle_breakpoint() end },
      { "<F3>",     function() require('dap').step_over() end },
      { "<F4>",     function() require('dap').step_into() end },
      { "<F5>",     function() require('dap').step_out() end },
      { "<F6>",     function() require('dap').run_to_cursor() end },
      { "<F12>",    function() require("dapui").toggle() end },
      { "<space>?", function() require("dapui").eval(nil, { enter = true }) end },
      -- { "<leader>d",  function() require('dap').toggle_breakpoint() end },
      -- { "<leader>x",  function() require('dap').continue() end },
      -- { "<leader>si", function() require('dap').step_into() end },
      -- { "<leader>so", function() require('dap').step_over() end },
    },
  },

  {
    "sphamba/smear-cursor.nvim",
    opts = {
      cursor_color = "#9d7cd8",
      smear_insert_mode = false
    },
  },

  {
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    opts = {
      prompt = '🪿 ',
    },
    keys = {
      {
        "ff",
        function()
          require("fff").find_files()
        end,
        desc = "Open file picker",
      },
    },
  },

  {
    'Civitasv/cmake-tools.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'stevearc/overseer.nvim', 'akinsho/toggleterm.nvim' },
    config = function()
      require("cmake-tools").setup {
        -- Customize as needed...
        cmake_command = "cmake",
        cmake_build_options = { "-j4" },
        cmake_build_directory = "build/${variant:buildType}"
      }
    end,
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        auto_approve = true,
        port = 9999, -- Port for the mcp-hub Express server
        config = vim.fn.expand("~/.config/nvim/mcpservers.json"),
        log = {
          level = vim.log.levels.WARN, -- Adjust verbosity (DEBUG, INFO, WARN, ERROR)
          to_file = true,
          file_path = vim.fn.expand("~/.local/state/nvim/mcphub.log"),
        },
        on_ready = function()
          vim.notify("MCP Hub backend server is initialized and ready.", vim.log.levels.INFO)
        end
      })
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ravitemer/mcphub.nvim",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "openai",
            tools = {
              mcp = {
                enabled = true,
              }
            }
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              -- MCP Tools
              make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
              show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
              add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
              show_result_in_chat = true,           -- Show tool results directly in chat buffer
              format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
              -- MCP Resources
              make_vars = true,                     -- Convert MCP resources to #variables for prompts
              -- MCP Prompts
              make_slash_commands = true,           -- Add MCP prompts as /slash commands
            }
          }
        }
      })
    end,
  }
}
