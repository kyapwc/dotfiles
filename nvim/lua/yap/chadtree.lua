local chadtree_settings = {
  options = {
    version_control = {
      enable = true,
    },
    show_hidden = false,
  },
  ignore = {
    name_exact = {
      ".DS_Store",
      ".git",
      ".husky",
      "tmp",
      "node_modules",
      "dist",
    },
  },
  theme = {
    highlights = {
      version_control = "",
    },
    text_colour_set = "nerdtree_syntax_dark",
  },
  view = {
    window_options = {
      number = true,
      relativenumber = true,
      wrap = false,
    },
  },
}

vim.api.nvim_set_var('chadtree_settings', chadtree_settings)
