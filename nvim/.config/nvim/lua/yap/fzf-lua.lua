local actions = require('fzf-lua.actions')
local fzfLua = require('fzf-lua')
local utils = require('fzf-lua.utils')

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

vim.keymap.set("n", "<space>ap", function()
  vim.notify('Fetching the list of PRs...', vim.log.levels.INFO, { title = "GitHub PRs" })
  local handle = io.popen("gh pr list --limit 250 --json title,number,url --jq '.[] | [.number, .title, .url] | @tsv'")
  if handle == nil then
    print("Failed to fetch PRs!")
    return
  end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then
    vim.notify("No PRs found or error fetching PRs!", vim.log.levels.WARN, { title = "GitHub PRs" })
    return
  end

  -- Step 2: Create list of PRs
  local prs = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(prs, line)
  end

  -- Step 3: Use fzf-lua to list PRs and approve selected PR
  fzfLua.fzf_exec(prs, {
    prompt = 'PRs> ',
    actions = {
      -- Approve the PR on pressing <Enter>
      ['default'] = function(selected)
        local pr_number = utils.strsplit("\t", selected[1])[1]
        if pr_number then
          local review_result = io.popen("gh pr review " .. pr_number .. " --approve 2>&1")
          if review_result == nil then
            vim.notify("Failed to approve PR #" .. pr_number, vim.log.levels.ERROR,
              { title = "GitHub PR Approval Error" })
            return
          end

          local output = review_result:read("*a")
          local success = review_result:close()

          if success and not output:match('failed') then
            vim.notify("Approved PR #" .. pr_number, vim.log.levels.INFO, { title = "GitHub PRs" })
          else
            -- Handle potential errors
            vim.notify("Failed to approve PR #" .. pr_number .. "\nError: " .. output,
              vim.log.levels.ERROR,
              { title = "GitHub PR Approval Error" }
            )
          end
        end
      end,

      -- Open PR in browser on <Ctrl-o>
      ['ctrl-o'] = function(selected)
        local _, _, pr_url = selected[1]:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
        if pr_url then
          if IS_LINUX() then
            os.execute("xdg-open " .. pr_url .. " &")
          else
            os.execute("open " .. pr_url .. " &")
          end
          vim.notify("Opened PR in browser: " .. pr_url, vim.log.levels.INFO, { title = "GitHub PRs" })
        end
      end,
    },
  })
end, { desc = "Approve PR" })
