require("twilight").setup({
  dimming = {
    alpha = 0.25,
  },
  treesitter = true,
  expand = {
    "method_definition",
    "lexical_declaration",
    "expression_statement",
    "variable_declarator",
    "function_declaration",
    "function",
    "method",
    "table",
    "if_statement",
  },
})
