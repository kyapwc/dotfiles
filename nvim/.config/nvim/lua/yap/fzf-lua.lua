local actions = require('fzf-lua.actions')
local fzfLua = require('fzf-lua')
local gh_functions = require('yap/custom_git')
local M = {}

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
      ["default"] = function(selected)
        local line = type(selected) == "table" and selected[1] or selected
        local selected_branch = line:match("^%*?%s*([^%s]+)") -- first token, skip leading "*"

        -- optional: if it comes back like "origin/foo" and you want "foo"
        selected_branch = selected_branch:gsub("^origin/", ""):gsub("^remotes/origin/", "")

        local pr_url = string.format("%s/pull/new/%s...%s", repo_url, selected_branch, current_branch)
        vim.fn.setreg("+", pr_url)
        vim.notify("PR Link Opened & In Clipboard")

        local handle = io.popen('open ' .. vim.fn.shellescape(pr_url))
        if handle then handle:close() end
      end,
    },
  })
end, { desc = "Create PR link for the current branch" })

function M.fzf_prs_workflow(prs, include_organization)
  fzfLua.fzf_exec(prs, {
    prompt = 'PRs (<C-o> Open PR, <Enter> to Approve, <C-x> Switch Repo, <C-y> Copy PR Url)> ',
    actions = {
      -- Approve the PR on pressing <Enter>
      ['default'] = function(selected)
        local pr_number = selected[1]:match("^[^\t]+")
        if pr_number then
          local review_command = "gh pr review " ..
              pr_number .. " --approve --repo " ..
              gh_functions.get_repo_name(include_organization) ..
              " 2>&1"

          local review_result = io.popen(review_command)
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
          vim.notify("Opened PR in browser: " .. pr_url, vim.log.levels.INFO, { title = "GitHub PRs" })
          if IS_LINUX() then
            os.execute("xdg-open " .. pr_url .. " &")
          else
            os.execute("open " .. pr_url .. " &")
          end
        end
      end,

      ['ctrl-x'] = function()
        local organizations = gh_functions.get_organization_list()
        M.fzf_organization_and_repo_selection(organizations, M.fzf_prs_workflow)
      end,

      ['ctrl-y'] = function(selected)
        local _, _, pr_url = selected[1]:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
        if pr_url then
          vim.notify("Copied PR URL into clipboard: " .. pr_url, vim.log.levels.INFO, { title = "GitHub PRs" })
          if IS_LINUX() then
            vim.notify("Not implemented yet")
          else
            os.execute("echo " .. pr_url .. " | pbcopy")
          end
        end
      end,
    },
  })
end

function M.fzf_organization_and_repo_selection(orgs, callback)
  fzfLua.fzf_exec(orgs, {
    prompt = 'Organization (Please choose organization)> ',
    actions = {
      ['default'] = function(selected)
        gh_functions.current_organization = selected[1]
        local repo_list = gh_functions.get_repo_list()

        fzfLua.fzf_exec(repo_list, {
          prompt = 'Repos (Please choose repo)> ',
          actions = {
            ['default'] = function(selectedRepo)
              local repos = gh_functions.set_and_fetch_repo(selectedRepo[1], true)
              callback(repos, true)
            end,
          },
        })
      end,
    },
  })
end

local function fetch_prs_and_select()
  vim.notify('Fetching the list of PRs...', vim.log.levels.INFO, { title = "GitHub PRs" })
  local prs = gh_functions.fetch_prs_for_repo()

  local repoName = gh_functions.get_repo_name()
  if not prs then
    vim.notify("No PRs found for " .. repoName .. '\nPlease choose an org and its repo to fetch new PRs',
      vim.log.levels.WARN, { title = "GitHub PRs" })
    local orgs = gh_functions.get_organization_list()

    M.fzf_organization_and_repo_selection(orgs, M.fzf_prs_workflow)
    return
  end

  M.fzf_prs_workflow(prs)
end

local function fetch_my_prs()
  local author = gh_functions.get_author()
  vim.notify("Fetching the list of PRs for `" .. author .. "`", vim.log.levels.INFO, { title = "GitHub PRs" })

  local prs = gh_functions.fetch_my_prs()

  if not prs or next(prs) == nil then
    vim.notify("No PRs found for " .. author .. " on " .. vim.fn.expand('%:p:h'), vim.log.levels.WARN,
      { title = "GitHub PRs" })
    return
  end

  fzfLua.fzf_exec(prs, {
    prompt = 'My PRs <Enter> to Open in Browser)> ',
    actions = {
      -- Approve the PR on pressing <Enter>
      -- Open PR in browser on <Ctrl-o>
      ['default'] = function(selected)
        local _, _, pr_url = selected[1]:match("([^\t]+)\t([^\t]+)\t([^\t]+)")
        if pr_url then
          vim.notify("Opened PR in browser: " .. pr_url, vim.log.levels.INFO, { title = "GitHub PRs" })
          if IS_LINUX() then
            os.execute("xdg-open " .. pr_url .. " &")
          else
            os.execute("open " .. pr_url .. " &")
          end
        end
      end,
    },
  })
end

vim.keymap.set("n", "<space>ap", fetch_prs_and_select, { desc = "Approve PR" })
vim.keymap.set("n", "<space>mpr", fetch_my_prs, { desc = "My PRs" })
