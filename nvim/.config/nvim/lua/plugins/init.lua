local plugins = {
  -- Treesitter and theme
  -- Pinned to the legacy `master` branch: `main` is a breaking rewrite that
  -- drops the `nvim-treesitter.configs` module API used in yap/treesitter.lua
  -- (and yap/config/lsp_new's hover treesitter-injection crash fix lives only
  -- on this branch's query_predicates.lua). Don't remove this pin without
  -- migrating that config to the new API first.
  { 'nvim-treesitter/nvim-treesitter', branch = 'master' },
  { 'nvim-treesitter/playground' },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },

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
  {
    'junegunn/fzf',
    build = './install --bin'
  },

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
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

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
    "sphamba/smear-cursor.nvim",
    opts = {
      cursor_color = "#9d7cd8",
      smear_insert_mode = false
    },
  },

  -- {
  --   "ravitemer/mcphub.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   },
  --   build = "npm install -g mcp-hub@latest",
  --   config = function()
  --     require("mcphub").setup({
  --       auto_approve = true,
  --       port = 9999, -- Port for the mcp-hub Express server
  --       config = vim.fn.expand("~/.config/nvim/mcpservers.json"),
  --       log = {
  --         level = vim.log.levels.WARN, -- Adjust verbosity (DEBUG, INFO, WARN, ERROR)
  --         to_file = true,
  --         file_path = vim.fn.expand("~/.local/state/nvim/mcphub.log"),
  --       },
  --       on_ready = function()
  --         vim.notify("MCP Hub backend server is initialized and ready.", vim.log.levels.INFO)
  --       end
  --     })
  --   end,
  -- },

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
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    config = function()
      local markview = require("markview")
      local presets = require("markview.presets").headings;

      markview.setup({
        markdown = { headings = presets.numbered }
      })
    end,
  },

  {
    "ThePrimeagen/99",
    config = function()
      local _99 = require("99")

      -- For logging that is to a file if you wish to trace through requests
      -- for reporting bugs, i would not rely on this, but instead the provided
      -- logging mechanisms within 99.
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)
      _99.setup({
        model = 'opencode/big-pickle',
        logger = {
          level = _99.DEBUG,
          path = '/tmp/99.debug',
          print_on_error = true,
        },

        --- Completions: #rules and @files in the prompt buffer
        completion = {
          -- I am going to disable these until i understand the
          -- problem better.  Inside of cursor rules there is also
          -- application rules, which means i need to apply these
          -- differently
          -- cursor_rules = "<custom path to cursor rules>"

          --- A list of folders where you have your own SKILL.md
          --- Expected format:
          --- /path/to/dir/<skill_name>/SKILL.md
          ---
          --- Example:
          --- Input Path:
          --- "scratch/custom_rules/"
          ---
          --- Output Rules:
          --- {path = "scratch/custom_rules/vim/SKILL.md", name = "vim"},
          --- ... the other rules in that dir ...
          ---
          custom_rules = {
            "scratch/custom_rules/",
          },

          --- Configure @file completion (all fields optional, sensible defaults)
          files = {
            -- enabled = true,
            -- max_file_size = 102400,     -- bytes, skip files larger than this
            -- max_files = 5000,            -- cap on total discovered files
            -- exclude = { ".env", ".env.*", "node_modules", ".git", ... },
          },

          --- What autocomplete do you use.  We currently only
          --- support cmp right now
          source = "cmp",
        },

        --- WARNING: if you change cwd then this is likely broken
        --- ill likely fix this in a later change
        ---
        --- md_files is a list of files to look for and auto add based on the location
        --- of the originating request.  That means if you are at /foo/bar/baz.lua
        --- the system will automagically look for:
        --- /foo/bar/AGENT.md
        --- /foo/AGENT.md
        --- assuming that /foo is project root (based on cwd)
        md_files = {
          "AGENT.md",
        },
      })

      -- take extra note that i have visual selection only in v mode
      -- technically whatever your last visual selection is, will be used
      -- so i have this set to visual mode so i dont screw up and use an
      -- old visual selection
      --
      -- likely ill add a mode check and assert on required visual mode
      -- so just prepare for it now
      vim.keymap.set("v", "99", function()
        _99.visual()
      end)

      --- if you have a request you dont want to make any changes, just cancel it
      vim.keymap.set("v", "9s", function()
        _99.stop_all_requests()
      end)
    end,
  },

  {
    "milanglacier/minuet-ai.nvim",
    lazy = false,
    config = function()
      require("minuet").setup({
        provider = "codestral",

        throttle = 1000,
        debounce = 400,

        virtualtext = {
          -- Automatically enable virtual text in every filetype.
          auto_trigger_ft = { "*" },
          auto_trigger_ignore_ft = {
            "TelescopePrompt",
            "snacks_picker_input",
            "oil",
          },

          keymap = {
            accept = "<Tab>",
            accept_line = "<C-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-e>",
          },
        },

        provider_options = {
          codestral = {
            model = "codestral-latest",
            api_key = "MISTRAL_API_KEY",
            end_point = "https://api.mistral.ai/v1/fim/completions",
            stream = true,

            optional = {
              max_tokens = 128,
              stop = { "\n\n" },
            },
          },
        },
      })
    end,
  }
}

if not IS_DEVCONTAINER() then
  local host_only = {
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
      'rrethy/vim-hexokinase',
      build = 'make hexokinase',
    },
    -- disable nvim-dap for now since i dont use it so much
    -- {
    --   "mfussenegger/nvim-dap",
    --   lazy = true,
    --   dependencies = {
    --     "rcarriga/nvim-dap-ui",
    --     {
    --       "microsoft/vscode-js-debug",
    --       version = "1.x",
    --       build = "npm i && npm run compile vsDebugServerBundle && mv dist out"
    --     }
    --   },
    --   keys = {
    --     { "<F1>",     function() require('dap').continue() end },
    --     { "<F2>",     function() require('dap').toggle_breakpoint() end },
    --     { "<F3>",     function() require('dap').step_over() end },
    --     { "<F4>",     function() require('dap').step_into() end },
    --     { "<F5>",     function() require('dap').step_out() end },
    --     { "<F6>",     function() require('dap').run_to_cursor() end },
    --     { "<F12>",    function() require("dapui").toggle() end },
    --     { "<space>?", function() require("dapui").eval(nil, { enter = true }) end },
    --     -- { "<leader>d",  function() require('dap').toggle_breakpoint() end },
    --     -- { "<leader>x",  function() require('dap').continue() end },
    --     -- { "<leader>si", function() require('dap').step_into() end },
    --     -- { "<leader>so", function() require('dap').step_over() end },
    --   },
    -- },
  }
  vim.list_extend(plugins, host_only)
end

return plugins
