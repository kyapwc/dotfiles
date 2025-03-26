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

return M
