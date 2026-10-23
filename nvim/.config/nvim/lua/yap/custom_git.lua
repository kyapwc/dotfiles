local M = {}

M.current_repo = nil
M.current_organization = nil

function M.get_organization_list()
  local handle = io.popen('gh org list')

  if not handle then return nil end

  local output = handle:read('*a')
  handle:close()

  local org_list = {}
  for line in output:gmatch("[^\r\n]+") do
    -- Skip lines containing "Showing" and filter only valid organization names
    if not line:match("^Showing") and line ~= "" then
      line = line:match("^%s*(.-)%s*$")
      table.insert(org_list, line)
    end
  end

  return org_list
end

function M.get_organization_list_async(callback)
  vim.system({ "sh", "-c", "gh org list" }, { text = true }, function(result)
    vim.schedule(function()
      local org_list = {}
      for line in (result.stdout or ""):gmatch("[^\r\n]+") do
        if not line:match("^Showing") and line ~= "" then
          line = line:match("^%s*(.-)%s*$")
          table.insert(org_list, line)
        end
      end
      callback(org_list)
    end)
  end)
end

function M.get_repo_list()
  local handle = io.popen('gh repo list ' ..
    M.current_organization .. " --visibility private --limit 250 --no-archived --json name | jq -r '.[].name'")

  if not handle then return nil end

  local repos = handle:read('*a')
  handle:close()

  if not repos or repos == "" then
    vim.notify("No repositories found for " .. M.current_organization, vim.log.levels.WARN, { title = "GitHub PRs" })
    return
  end

  local repo_list = {}
  for line in repos:gmatch("[^\r\n]+") do
    line = line:match("^%s*(.-)%s*$") -- Trim leading/trailing spaces for each line
    if line ~= "" then
      table.insert(repo_list, line)
    end
  end

  return repo_list
end

function M.get_current_repo()
  local handle = io.popen('cd ' ..
    vim.fn.expand('%:p:h') .. ' && gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null')

  if not handle then return nil end

  local repo = handle:read('*a'):gsub('%s+', '')
  handle:close()

  return repo ~= '' and repo or nil
end

function M.fetch_prs_for_repo(repo_name_include_organization)
  if not repo_name_include_organization then
    repo_name_include_organization = false
  end

  if not M.current_repo then
    M.current_repo = M.get_current_repo()
  end

  local repoName = M.get_repo_name(repo_name_include_organization)
  local cmd = string.format(
    "gh pr list --limit 250 --json title,number,url --repo " ..
    repoName .. " | jq -r '.[] | [.number, .title, .url] | @tsv'"
  )
  local handle = io.popen(cmd)

  if not handle then
    vim.notify('Failed to fetch PRs!', vim.log.levels.ERROR, { title = "GitHub PRs" })
    return
  end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then
    return
  end

  local prs = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(prs, line)
  end

  return prs
end

function M.set_and_fetch_repo(repo, include_organization)
  M.current_repo = repo
  vim.notify('Switched to repository: ' .. repo, vim.log.levels.INFO, { title = "GitHub PRs" })

  return M.fetch_prs_for_repo(include_organization)
end

function M.approve_pr_workflow()
  if not M.current_repo then
    M.current_repo = M.get_current_repo()
  end

  local prs = M.fetch_prs_for_repo()

  if not prs then return end

  return prs
end

function M.get_repo_name(include_organization)
  if not include_organization then
    include_organization = false
  end

  local repoName = 'https://github.com/'
  if include_organization == true then
    repoName = repoName .. M.current_organization .. '/' .. M.current_repo
  else
    repoName = repoName .. M.current_repo
  end

  return repoName
end

-- The repo the PR popup workflow (<space>ap) is currently pointed at, as a
-- bare "owner/repo" string. Distinct from M.current_repo/M.current_organization
-- above, which belong to the older org->repo fzf-list workflow and store the
-- repo name split across two fields.
M.active_repo = nil

-- Most PRs reviewed day-to-day are in the main repo, regardless of which
-- project's cwd nvim happens to be open in -- so default there rather than
-- to a cwd-detected repo (<space>ar or "repo#123" still switch freely).
local DEFAULT_REPO = "respond-io/respond-io"

function M.get_active_repo()
  if M.active_repo then return M.active_repo end
  M.active_repo = DEFAULT_REPO
  return M.active_repo
end

function M.set_active_repo(repo)
  M.active_repo = repo
end

-- Repo list is slow to fetch (several `gh repo list` calls across orgs), so
-- it's cached to disk for 30 days on top of the in-memory cache -- a fresh
-- `nvim` still gets an instant list instead of re-paying that cost every
-- session. Pass force_refresh to bypass both caches.
local REPO_CACHE_PATH = vim.fn.stdpath('cache') .. '/gh_repo_list.json'
local REPO_CACHE_TTL_SECONDS = 30 * 24 * 60 * 60

local function read_repo_disk_cache()
  local f = io.open(REPO_CACHE_PATH, 'r')
  if not f then return nil end
  local content = f:read('*a')
  f:close()

  local ok, data = pcall(vim.json.decode, content)
  if not ok or type(data) ~= 'table' or type(data.repos) ~= 'table' or type(data.timestamp) ~= 'number' then
    return nil
  end
  if (os.time() - data.timestamp) > REPO_CACHE_TTL_SECONDS then
    return nil
  end

  return data.repos
end

local function write_repo_disk_cache(repos)
  local f = io.open(REPO_CACHE_PATH, 'w')
  if not f then return end
  f:write(vim.json.encode({ timestamp = os.time(), repos = repos }))
  f:close()
end

-- Lists every repo the user can see (their own + every org they belong to)
-- as "owner/repo" strings, for the repo picker. Pass force_refresh to bypass
-- both the in-memory and on-disk caches and hit `gh` again.
function M.list_repos_for_picker(force_refresh)
  if M._repo_list_cache and not force_refresh then
    return M._repo_list_cache
  end

  if not force_refresh then
    local cached = read_repo_disk_cache()
    if cached then
      M._repo_list_cache = cached
      return cached
    end
  end

  vim.notify("Fetching repo list from GitHub (cached for 30 days after this)...", vim.log.levels.INFO,
    { title = "GitHub PRs" })

  local repos = {}
  local seen = {}

  local function add_repos(cmd)
    local handle = io.popen(cmd)
    if not handle then return end
    local output = handle:read('*a')
    handle:close()
    for line in output:gmatch("[^\r\n]+") do
      line = line:match("^%s*(.-)%s*$")
      if line ~= "" and not seen[line] then
        seen[line] = true
        table.insert(repos, line)
      end
    end
  end

  add_repos("gh repo list --limit 250 --no-archived --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null")

  for _, org in ipairs(M.get_organization_list() or {}) do
    add_repos(string.format(
      "gh repo list %s --limit 250 --no-archived --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null", org))
  end

  M._repo_list_cache = repos
  write_repo_disk_cache(repos)
  return repos
end

-- Non-blocking twin of list_repos_for_picker: same caches, same repo list,
-- but chains the `gh repo list` calls (one for personal repos, one per org)
-- through vim.system instead of io.popen, so a cold cache (or a forced
-- refresh) doesn't freeze the UI for however long those calls take.
function M.list_repos_for_picker_async(force_refresh, callback)
  if M._repo_list_cache and not force_refresh then
    callback(M._repo_list_cache)
    return
  end

  if not force_refresh then
    local cached = read_repo_disk_cache()
    if cached then
      M._repo_list_cache = cached
      callback(cached)
      return
    end
  end

  vim.notify("Fetching repo list from GitHub (cached for 30 days after this)...", vim.log.levels.INFO,
    { title = "GitHub PRs" })

  local repos = {}
  local seen = {}

  local function add_repos(output)
    for line in output:gmatch("[^\r\n]+") do
      line = line:match("^%s*(.-)%s*$")
      if line ~= "" and not seen[line] then
        seen[line] = true
        table.insert(repos, line)
      end
    end
  end

  local function run_and_add(cmd, next_fn)
    vim.system({ "sh", "-c", cmd }, { text = true }, function(result)
      vim.schedule(function()
        add_repos(result.stdout or "")
        next_fn()
      end)
    end)
  end

  run_and_add("gh repo list --limit 250 --no-archived --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null",
    function()
      M.get_organization_list_async(function(orgs)
        local i = 0
        local function next_org()
          i = i + 1
          local org = orgs[i]
          if not org then
            M._repo_list_cache = repos
            write_repo_disk_cache(repos)
            callback(repos)
            return
          end
          run_and_add(string.format(
            "gh repo list %s --limit 250 --no-archived --json nameWithOwner -q '.[].nameWithOwner' 2>/dev/null", org),
            next_org)
        end
        next_org()
      end)
    end)
end

-- Resolves a bare repo name (no "owner/") against the cached repo list, so
-- "myrepo#123" typed into the PR prompt doesn't require spelling out the
-- owner. Returns nil without hitting the network if nothing cached matches.
function M.resolve_repo_name(name)
  if name:find("/", 1, true) then return name end

  for _, r in ipairs(M._repo_list_cache or read_repo_disk_cache() or {}) do
    if r:match("/" .. vim.pesc(name) .. "$") then
      return r
    end
  end
  return nil
end

-- Cached for the session: used to optimistically update the popup's local
-- state after approving/merging (an extra "whoami" call is still far cheaper
-- than the full re-fetch it replaces, and only ever runs once).
M._viewer_login = nil

function M.get_viewer_login()
  if M._viewer_login then return M._viewer_login end

  local handle = io.popen("gh api user -q .login 2>/dev/null")
  if not handle then return nil end

  local login = handle:read("*a"):gsub("%s+", "")
  handle:close()

  if login ~= "" then M._viewer_login = login end
  return M._viewer_login
end

-- Non-blocking twin, for pre-warming the cache (see pr_popup.lua) so the
-- synchronous M.get_viewer_login() call made right after approving/merging
-- -- itself needed so the optimistic local update can show the right
-- username -- almost always just returns the already-cached value instantly.
function M.get_viewer_login_async(callback)
  if M._viewer_login then
    callback(M._viewer_login)
    return
  end

  vim.system({ "sh", "-c", "gh api user -q .login" }, { text = true }, function(result)
    vim.schedule(function()
      local login = (result.stdout or ""):gsub("%s+", "")
      if login ~= "" then M._viewer_login = login end
      callback(M._viewer_login)
    end)
  end)
end

function M.get_author()
  local handle = io.popen('git config --list')

  if not handle then return nil end

  local result = handle:read('*a')
  handle:close()

  local author = nil
  for line in result:gmatch("[^\r\n]+") do
    if line:match("^user.email") then
      author = line:match("^user.email=(.*)$")
      break
    end
  end

  return author
end

-- Fetch full PR details (title, body, comments, etc.) as a decoded table,
-- for building a preview popup before approving/merging. Reviews come from
-- a separate call (see list_pr_reviews_with_comments) since gh pr view's
-- GraphQL `reviews` field only carries a review's own summary text, missing
-- the inline comments left on specific diff lines -- which is usually where
-- the actual review content lives for line-by-line reviewers (bots included).
local PR_VIEW_FIELDS = table.concat({
  "number", "title", "url", "author", "body", "state", "isDraft",
  "headRefName", "baseRefName", "mergeable", "mergedAt", "mergedBy",
  "comments", "commits",
  "additions", "deletions", "changedFiles",
}, ",")

function M.view_pr_json(pr_number, repo)
  local cmd = string.format("gh pr view %s --repo %s --json %s 2>&1", pr_number, repo, PR_VIEW_FIELDS)
  local handle = io.popen(cmd)
  if not handle then return nil, "Failed to run gh pr view" end

  local output = handle:read("*a")
  local ok = handle:close()
  if not ok then
    return nil, output
  end

  local decode_ok, data = pcall(vim.json.decode, output)
  if not decode_ok then
    return nil, "Failed to parse PR JSON: " .. output
  end

  return data, nil
end

-- Same as view_pr_json but non-blocking: calls `callback(data, err)` once
-- `gh` returns, instead of making the caller wait on io.popen. Used for
-- reconciling the popup's optimistic local state with the real server state
-- in the background, without freezing the UI on another `gh pr view` call.
function M.view_pr_json_async(pr_number, repo, callback)
  local cmd = string.format("gh pr view %s --repo %s --json %s", pr_number, repo, PR_VIEW_FIELDS)
  vim.system({ "sh", "-c", cmd }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        callback(nil, result.stderr ~= "" and result.stderr or result.stdout)
        return
      end
      local ok, data = pcall(vim.json.decode, result.stdout)
      callback(ok and data or nil, ok and nil or ("Failed to parse PR JSON: " .. result.stdout))
    end)
  end)
end

local function run_gh_json(cmd)
  local handle = io.popen(cmd)
  if not handle then return nil, "Failed to run: " .. cmd end

  local output = handle:read("*a")
  local ok = handle:close()
  if not ok then return nil, output end

  local decode_ok, data = pcall(vim.json.decode, output)
  if not decode_ok then return nil, "Failed to parse JSON: " .. output end

  return data, nil
end

local function run_gh_json_async(cmd, callback)
  vim.system({ "sh", "-c", cmd }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        callback(nil, result.stderr ~= "" and result.stderr or result.stdout)
        return
      end
      local ok, data = pcall(vim.json.decode, result.stdout)
      callback(ok and data or nil, ok and nil or ("Failed to parse JSON: " .. result.stdout))
    end)
  end)
end

-- Shared by list_pr_reviews_with_comments and its async twin: reviews,
-- normalized to {author={login=...}, state=..., body=..., inline_comments={...}}.
-- `body` is the review's own summary text (often empty for line-by-line
-- reviewers -- gh pr view's GraphQL reviews field stops there, missing the
-- actual feedback). `inline_comments` carries each comment left on a specific
-- diff line, including `diff_hunk` -- the surrounding diff context GitHub
-- shows above the comment on the PR page -- so the popup can render it too.
local function normalize_reviews(reviews, comments)
  local comments_by_review = {}
  for _, c in ipairs(comments or {}) do
    local rid = c.pull_request_review_id
    if rid then
      comments_by_review[rid] = comments_by_review[rid] or {}
      table.insert(comments_by_review[rid], {
        path = c.path,
        line = c.line or c.original_line,
        body = c.body or "",
        diff_hunk = c.diff_hunk or "",
      })
    end
  end

  local result = {}
  for _, r in ipairs(reviews) do
    table.insert(result, {
      author = { login = r.user and r.user.login or "unknown" },
      state = r.state,
      body = r.body or "",
      inline_comments = comments_by_review[r.id] or {},
    })
  end

  return result
end

function M.list_pr_reviews_with_comments(pr_number, repo)
  local reviews, err = run_gh_json(string.format("gh api repos/%s/pulls/%s/reviews --paginate 2>&1", repo, pr_number))
  if not reviews then return nil, err end

  local comments = run_gh_json(string.format("gh api repos/%s/pulls/%s/comments --paginate 2>&1", repo, pr_number))
    or {}

  return normalize_reviews(reviews, comments), nil
end

-- Non-blocking twin of list_pr_reviews_with_comments, calling
-- `callback(reviews, err)` once both `gh api` calls return.
function M.list_pr_reviews_with_comments_async(pr_number, repo, callback)
  run_gh_json_async(string.format("gh api repos/%s/pulls/%s/reviews --paginate", repo, pr_number),
    function(reviews, err)
      if not reviews then
        callback(nil, err)
        return
      end

      run_gh_json_async(string.format("gh api repos/%s/pulls/%s/comments --paginate", repo, pr_number),
        function(comments)
          callback(normalize_reviews(reviews, comments or {}), nil)
        end)
    end)
end

function M.approve_pr(pr_number, repo)
  local cmd = string.format("gh pr review %s --approve --repo %s 2>&1", pr_number, repo)
  local handle = io.popen(cmd)
  if not handle then return false, "Failed to run gh pr review" end

  local output = handle:read("*a")
  local ok = handle:close()

  return ok and not output:match("[Ff]ailed"), output
end

-- Best-effort merge: tries the requested strategy ("merge" | "squash" |
-- "rebase") and simply reports failure back to the caller -- the PR stays
-- approved either way, merging is just a convenience on top.
function M.merge_pr(pr_number, repo, strategy)
  local flag = ({ merge = "--merge", squash = "--squash", rebase = "--rebase" })[strategy] or "--merge"
  local cmd = string.format("gh pr merge %s --repo %s %s 2>&1", pr_number, repo, flag)
  local handle = io.popen(cmd)
  if not handle then return false, "Failed to run gh pr merge" end

  local output = handle:read("*a")
  local ok = handle:close()

  return ok and not output:match("[Ff]ailed") and not output:lower():match("error"), output
end

-- Non-blocking: runs `cmd` via the shell and calls `callback(output, exit_ok)`
-- once it exits, instead of making the caller wait on io.popen. `exit_ok` is
-- just the process exit code being 0 -- callers still grep `output` for
-- "failed"/"error" the same way the sync versions do, since `gh` sometimes
-- exits 0 on a soft failure.
local function run_shell_async(cmd, callback)
  vim.system({ "sh", "-c", cmd }, { text = true }, function(result)
    vim.schedule(function()
      callback((result.stdout or "") .. (result.stderr or ""), result.code == 0)
    end)
  end)
end

function M.approve_pr_async(pr_number, repo, callback)
  local cmd = string.format("gh pr review %s --approve --repo %s", pr_number, repo)
  run_shell_async(cmd, function(output, exit_ok)
    callback(exit_ok and not output:match("[Ff]ailed"), output)
  end)
end

function M.merge_pr_async(pr_number, repo, strategy, callback)
  local flag = ({ merge = "--merge", squash = "--squash", rebase = "--rebase" })[strategy] or "--merge"
  local cmd = string.format("gh pr merge %s --repo %s %s", pr_number, repo, flag)
  run_shell_async(cmd, function(output, exit_ok)
    callback(exit_ok and not output:match("[Ff]ailed") and not output:lower():match("error"), output)
  end)
end

function M.fetch_my_prs()
  local command = string.format(
    "gh pr list --limit 250 --json title,number,url --author '@me' | jq -r '.[] | [.number, .title, .url] | @tsv'"
  )

  local handle = io.popen(command)
  if not handle then return nil end

  local result = handle:read("*a")
  handle:close()

  local prs = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(prs, line)
  end

  return prs
end

return M
