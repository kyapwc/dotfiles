local actions = require('fzf-lua.actions')
local fzfLua = require('fzf-lua')

fzfLua.setup({
  lsp = {
    code_actions = {
      previewer = 'codeaction_native',
      preview_pager = "delta --side-by-side --width=$FZF_PREVIEW_COLUMNS --hunk-header-style='omit' --file-style='omit'",
    },
  },
  file_ignore_patterns = { "undodir$", "dist" },
  previewers = {
    builtin = {
      extensions = {
        ["png"] = { "viu", "-b" },
        ["jpg"] = { "viu", "-b" },
      },
    },
  },
  fzf_opts = {
    ['--layout'] = 'reverse-list',
  },
  winopts = {
    height = 0.4,
    width = 1.0,
    row = 1.0,
    -- row = 0.5,
    border = 'rounded',
    preview = {
      layout = 'horizontal',
      foldenable = true,
      signcolumn = "yes",
    },
  },
  actions = {
    files = {
      -- ['default'] = actions.file_edit,
      ['default'] = actions.file_edit_or_qf,
      ['ctrl-v'] = actions.file_vsplit,
    }
  },
  keymap = {
    builtin = {
      ["<C-u>"] = 'preview-page-up',
      ["<C-d>"] = 'preview-page-down',
    },
  },
  oldfiles = {
    prompt = "History❯ ",
    cwd_only = true,
  }
})

local function get_current_branch()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD")
  if handle then
    local branch = handle:read("*a"):gsub("%s+", "")
    handle:close()
    return branch
  end
  return nil
end

local function get_repo_url()
  -- local handle = io.popen("git config --get remote.origin.url")
  local handle = io.popen('git ls-remote --get-url origin')
  if handle then
    local origin_url = handle:read("*a"):gsub("%s+", "")
    handle:close()

    -- Convert SSH URL to HTTPS if needed
    if origin_url:find("git@github.com:") then
      origin_url = origin_url:gsub("git@github.com:", "https://github.com/")
    end

    -- Remove .git suffix if present
    origin_url = origin_url:gsub("%.git$", "")
    return origin_url
  end
  return nil
end

-- Mapping to create the GitHub PR link
vim.keymap.set("n", "<space>pr", function()
  local current_branch = get_current_branch()
  if not current_branch then
    vim.notify("Failed to retrieve current Git branch!", vim.log.levels.ERROR)
    return
  end

  local repo_url = get_repo_url()
  if not repo_url then
    vim.notify("Failed to retrieve Git repository URL!", vim.log.levels.ERROR)
    return
  end

  -- Open fzf-lua.git_branches() and create a PR link
  fzfLua.git_branches({
    actions = {
      ["default"] = function(selected_branch)
        if type(selected_branch) == "table" then
          selected_branch = string.gsub(selected_branch[1], "%s+", "")
        end

        local pr_url = string.format("%s/pull/new/%s...%s", repo_url, selected_branch, current_branch)
        vim.fn.setreg("+", pr_url)
        vim.notify("PR Link Opened & In Clipboard")

        local handle = io.popen('open ' .. pr_url)
        if handle then
          handle:close()
        end
      end,
    },
  })
end, { desc = "Create PR link for the current branch" })
