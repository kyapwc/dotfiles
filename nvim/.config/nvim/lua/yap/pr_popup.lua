local gh = require('yap/custom_git')
local fzfLua = require('fzf-lua')
local markview_ok, markview = pcall(require, 'markview')
local markview_spec_ok, markview_spec = pcall(require, 'markview.spec')

local M = {}

-- Neovim's floating-window default is 50, which nvim-notify's windows also
-- use (it never sets its own). All of this module's popups ask for
-- something lower so a notify() fired while one is open always draws on
-- top of it instead of being hidden behind it.
local POPUP_ZINDEX = 45

-- Review text uses bare "[COMMENTED]"/"[critical]"/"[bot]" brackets a lot,
-- none of which are actual links -- but markdown's shortcut-reference-link
-- syntax is just "[text]", so markview's hyperlink renderer lights all of
-- them up with a link icon/highlight anyway, stomping on the severity-tag
-- highlight underneath and adding visual noise. Disabled just for this
-- popup's render calls, on top of a copy of the user's real config so every
-- other markview setting (their numbered-headings preset, code spans, etc.)
-- still applies normally.
local function markview_render_config()
  if not markview_spec_ok then return nil end
  local ok, cfg = pcall(vim.tbl_deep_extend, "force", vim.deepcopy(markview_spec.config), {
    markdown_inline = { hyperlinks = { enable = false } },
  })
  return ok and cfg or nil
end

-- "[critical]"/"[important]"/etc severity tags that review tools (code-review
-- bots especially) prefix their findings with -- colored via the built-in
-- Diagnostic highlight groups so they already match whatever palette the
-- colorscheme uses for errors/warnings/hints.
local SEVERITY_HL = {
  critical = "DiagnosticError",
  blocking = "DiagnosticError",
  important = "DiagnosticWarn",
  major = "DiagnosticWarn",
  suggestion = "DiagnosticInfo",
  minor = "DiagnosticHint",
  nit = "DiagnosticHint",
}

local function highlight_severity_tags(buf, lines)
  for i, line in ipairs(lines) do
    for word_start, word, word_end in line:gmatch("()%[(%a+)%]()") do
      local hl = SEVERITY_HL[word:lower()]
      if hl then
        vim.api.nvim_buf_add_highlight(buf, -1, hl, i - 1, word_start - 1, word_end - 1)
      end
    end
  end
end

-- Renders the buffer through markview (if installed) for rich markdown --
-- headings, bold, code spans, lists -- instead of plain text. strict_render
-- is markview's on-demand API: it ignores markview's usual filetype/buftype
-- auto-attach rules (which skip scratch "nofile" buffers like this popup's),
-- so it has to be told explicitly to render, and to re-render after an edit.
local function render_markdown(buf, first_time)
  if not markview_ok then return end

  pcall(vim.treesitter.start, buf, "markdown")
  pcall(function()
    if not first_time then
      markview.strict_render:clear(buf)
    end
    markview.strict_render:render(buf, nil, markview_render_config())
  end)
end

-- Legend entries, grouped by what they relate to. Rendered as an actual
-- aligned table (fixed-width columns, no border characters) with a blank
-- line between groups standing in for a section break -- plain alignment and
-- whitespace read far easier than one dense run-on line per group.
local LEGEND_GROUPS = {
  { { "a", "approve" }, { "m", "approve+merge" }, { "s", "approve+squash" }, { "r", "approve+rebase" } },
  { { "M", "merge only (no approve)" } },
  { { "d", "diff" }, { "o", "open" }, { "y", "copy url" }, { "R", "switch repo" } },
  { { "<C-r>", "reload now (auto every 10s)" } },
  { { "<space>", "expand/collapse/view diff" }, { "j/k", "next/prev item" } },
  { { "q/<Esc>", "close" } },
}
local LEGEND_COLS = 2
local LEGEND_COL_GAP = "    "

-- Builds the footer's text lines plus the 0-indexed highlight spans for each
-- key, so open_floating_window can color the keys distinctly from their
-- descriptions. Column widths are computed once across every group so keys
-- and descriptions line up like table columns all the way down the footer.
local function build_legend()
  -- Each entry becomes {group_idx, col, key, desc}; a blank line is inserted
  -- between groups when rendering, not stored as a row here.
  local rows = {}
  for group_idx, group in ipairs(LEGEND_GROUPS) do
    for i = 1, #group, LEGEND_COLS do
      local row = { group_idx = group_idx }
      for c = 0, LEGEND_COLS - 1 do
        row[c + 1] = group[i + c]
      end
      table.insert(rows, row)
    end
  end

  local key_width, desc_width = {}, {}
  for _, row in ipairs(rows) do
    for c = 1, LEGEND_COLS do
      local item = row[c]
      if item then
        key_width[c] = math.max(key_width[c] or 0, #item[1])
        desc_width[c] = math.max(desc_width[c] or 0, #item[2])
      end
    end
  end

  local lines = {}
  local highlights = {}
  local line_idx = 0
  local prev_group

  for _, row in ipairs(rows) do
    if prev_group and row.group_idx ~= prev_group then
      lines[#lines + 1] = ""
      line_idx = line_idx + 1
    end
    prev_group = row.group_idx

    local line = ""
    for c = 1, LEGEND_COLS do
      local item = row[c]
      if item then
        if c > 1 then line = line .. LEGEND_COL_GAP end
        local col_start = #line
        line = line .. item[1] .. string.rep(" ", key_width[c] - #item[1])
        table.insert(highlights, { line = line_idx, col_start = col_start, col_end = col_start + #item[1] })
        line = line .. "  " .. item[2]
        if c < LEGEND_COLS then
          line = line .. string.rep(" ", desc_width[c] - #item[2])
        end
      end
    end
    lines[#lines + 1] = line
    line_idx = line_idx + 1
  end

  return lines, highlights
end

-- Opens a scrollable content window plus a small non-scrolling "legend"
-- window pinned directly under it, so the keymap hints stay visible no
-- matter where the content window is scrolled to.
local function open_floating_window(lines, opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local footer_lines = opts.footer or {}
  local footer_height = #footer_lines
  local has_footer = footer_height > 0

  local outer_height = opts.height or math.floor(vim.o.lines * 0.8)
  local content_height = math.max(outer_height - (has_footer and (footer_height + 2) or 0), 5)

  local total_visual_height = content_height + 2 + (has_footer and (footer_height + 2) or 0)
  local base_row = math.max(math.floor((vim.o.lines - total_visual_height) / 2), 0)
  local base_col = math.max(math.floor((vim.o.columns - width) / 2), 0)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = opts.filetype or "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = content_height,
    row = base_row,
    col = base_col,
    style = "minimal",
    border = "rounded",
    title = opts.title,
    title_pos = "center",
    -- Below the default 50 (what nvim-notify's windows use, unset) so
    -- notifications fired while this popup is open always render on top of
    -- it instead of being hidden behind it.
    zindex = POPUP_ZINDEX,
  })

  local footer_buf, footer_win
  if has_footer then
    footer_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(footer_buf, 0, -1, false, footer_lines)
    vim.bo[footer_buf].modifiable = false
    vim.bo[footer_buf].bufhidden = "wipe"

    footer_win = vim.api.nvim_open_win(footer_buf, false, {
      relative = "editor",
      width = width,
      height = footer_height,
      row = base_row + content_height + 2,
      col = base_col,
      style = "minimal",
      border = "rounded",
      focusable = false,
      noautocmd = true,
      zindex = POPUP_ZINDEX,
    })

    -- Keys get their own bright highlight (set by the caller); the rest of
    -- the footer stays at normal brightness instead of being dimmed as a
    -- whole, which made it hard to read against the border/background.
    for _, h in ipairs(opts.footer_highlights or {}) do
      vim.api.nvim_buf_add_highlight(footer_buf, -1, "Function", h.line, h.col_start, h.col_end)
    end
  end

  return buf, win, footer_buf, footer_win
end

-- Runs `cmd` (expected to end in a delta/pager pipeline) in a full-screen
-- terminal popup. Shared by the whole-PR diff and single-commit diff views.
local function open_pager_popup(title, cmd)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
    zindex = POPUP_ZINDEX,
  })

  vim.fn.termopen(cmd, {
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end,
  })
  vim.cmd("startinsert")

  local close = function()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
  end
  vim.keymap.set("t", "q", function()
    vim.cmd("stopinsert")
    close()
  end, { buffer = buf, nowait = true })
  vim.keymap.set("n", "q", close, { buffer = buf, nowait = true })
end

local function open_diff_popup(pr_number, repo)
  local width = math.floor(vim.o.columns * 0.9)
  open_pager_popup(
    string.format(" PR #%s diff (q to go back) ", pr_number),
    string.format(
      "gh pr diff %s --repo %s | delta --paging=always --side-by-side --width=%d --hunk-header-style=omit",
      pr_number, repo, width
    )
  )
end

local function open_commit_diff_popup(sha, repo)
  local width = math.floor(vim.o.columns * 0.9)
  open_pager_popup(
    string.format(" Commit %s diff (q to go back) ", sha:sub(1, 7)),
    string.format(
      'gh api -H "Accept: application/vnd.github.v3.diff" repos/%s/commits/%s | ' ..
      "delta --paging=always --side-by-side --width=%d --hunk-header-style=omit",
      repo, sha, width
    )
  )
end

-- Wraps a comment/review body into a toggleable block: collapsed shows just
-- the first line, expanded shows everything. `expanded` lives on the table
-- itself so it survives buffer re-renders triggered by <space>. GitHub often
-- leaves a review's own body empty (e.g. a bot that posts its write-up as a
-- separate issue comment instead) -- mark that explicitly so it's clear
-- there's nothing to expand, rather than looking like a broken toggle.
local function make_collapsible(body, placeholder)
  if not body or body == "" then
    return { full_lines = { placeholder or "(empty)" }, expanded = false, empty = true }
  end

  local full_lines = vim.split(body, "\n")
  if #full_lines > 1 and full_lines[#full_lines] == "" then
    table.remove(full_lines, #full_lines)
  end
  if #full_lines == 0 then
    full_lines = { "" }
  end
  return { full_lines = full_lines, expanded = false }
end

-- Indent for everything under a review: prose (summary, inline comment text,
-- "`path:line`" headers) as well as our own ```diff fence. Markdown only
-- recognizes a fenced code block when its delimiter lines have <=3 leading
-- spaces, so this has to stay shallow -- and it has to apply to the prose
-- too, since a comment's own body can embed its own fence (GitHub's
-- "```suggestion" blocks), which needs the same <=3-space room to render as
-- a real code block instead of plain "indented code" text.
local REVIEW_TEXT_INDENT = "   "
local REVIEW_FENCE_INDENT = "   "
local MAX_DIFF_HUNK_LINES = 14

-- A review's displayable content: its own summary text (often empty) plus
-- every inline comment left on a specific diff line. `expanded` lives here
-- so it survives buffer re-renders triggered by <space>.
local function build_review_block(review)
  return {
    summary = review.body or "",
    inline = review.inline_comments or {},
    expanded = false,
  }
end

local function review_has_content(block)
  return block.summary ~= "" or #block.inline > 0
end

-- GitHub's diff_hunk always ends at (or right by) the commented line, so
-- keeping just the tail mirrors what GitHub itself shows by default above an
-- inline comment, instead of dumping the whole hunk (which can be the entire
-- file when a comment lands on a newly-added file).
local function trim_diff_hunk(diff_hunk)
  local hunk_lines = vim.split(diff_hunk, "\n")
  if #hunk_lines <= MAX_DIFF_HUNK_LINES then return hunk_lines end

  local trimmed = {}
  for i = #hunk_lines - MAX_DIFF_HUNK_LINES + 1, #hunk_lines do
    table.insert(trimmed, hunk_lines[i])
  end
  return trimmed
end

-- Renders a review block's full, already-indented content: summary, each
-- inline comment, and (when it has one) its diff context as a real ```diff
-- fenced block -- markview has a built-in renderer for that language
-- specifically (bordered box, "Diff" label, +/- lines colored per-line), so
-- there's no need to color it by hand here.
local function render_review_body(block)
  local lines = {}

  if block.summary ~= "" then
    for _, l in ipairs(vim.split(block.summary, "\n")) do
      table.insert(lines, REVIEW_TEXT_INDENT .. l)
    end
  end

  for _, c in ipairs(block.inline) do
    if #lines > 0 then table.insert(lines, "") end
    table.insert(lines, REVIEW_TEXT_INDENT .. string.format("`%s:%s`", c.path or "?", c.line or "?"))

    if c.body and c.body ~= "" then
      for _, l in ipairs(vim.split(c.body, "\n")) do
        table.insert(lines, REVIEW_TEXT_INDENT .. l)
      end
    end

    if c.diff_hunk and c.diff_hunk ~= "" then
      table.insert(lines, "")
      -- GitHub's diff_hunk is just the "@@ ... @@" hunk, never the filename
      -- (that lives in a separate "diff --git"/"+++" line GitHub doesn't
      -- give us here) -- repeat the path right above the fence so it's
      -- visible without scrolling back up past the whole comment body.
      table.insert(lines, REVIEW_TEXT_INDENT .. string.format("`%s:%s`", c.path or "?", c.line or "?"))
      table.insert(lines, REVIEW_FENCE_INDENT .. "```diff")
      for _, l in ipairs(trim_diff_hunk(c.diff_hunk)) do
        table.insert(lines, REVIEW_FENCE_INDENT .. l)
      end
      table.insert(lines, REVIEW_FENCE_INDENT .. "```")
    end
  end

  return lines
end

local function build_state(pr)
  local state = { comment_blocks = {}, review_blocks = {} }
  for i, c in ipairs(pr.comments or {}) do
    state.comment_blocks[i] = make_collapsible(c.body, "(no comment text)")
  end
  for i, r in ipairs(pr.reviews or {}) do
    state.review_blocks[i] = build_review_block(r)
  end
  return state
end

-- Appends a collapsible block's lines to `lines` and returns the 0-indexed
-- [start, finish] range it occupies, so the caller can register it for
-- <space> hit-testing when it has more than one line.
local function append_collapsible(lines, block, indent)
  local start = #lines
  if #block.full_lines <= 1 then
    table.insert(lines, indent .. (block.full_lines[1] or ""))
  elseif block.expanded then
    for _, l in ipairs(block.full_lines) do
      table.insert(lines, indent .. l)
    end
  else
    table.insert(lines, indent .. block.full_lines[1])
    table.insert(lines, indent .. string.format("… +%d more line(s) (<space> to expand)", #block.full_lines - 1))
  end
  return start, #lines - 1
end

-- Same idea as append_collapsible, but for a review block: collapsed shows
-- just the first line, expanded shows the summary, every inline comment and
-- its diff context. render_review_body's lines already carry their own
-- indentation (prose vs. fence need different amounts), so this doesn't add
-- any more. Returns (start, finish, toggleable).
local function append_review_block(lines, block)
  local start = #lines

  if not review_has_content(block) then
    table.insert(lines, REVIEW_TEXT_INDENT .. "(no review text — see Comments below, if any)")
    return start, #lines - 1, false
  end

  local body_lines = render_review_body(block)

  if #body_lines <= 1 then
    table.insert(lines, body_lines[1] or "")
    return start, #lines - 1, false
  end

  if not block.expanded then
    table.insert(lines, body_lines[1])
    table.insert(lines, REVIEW_TEXT_INDENT .. string.format("… +%d more line(s) (<space> to expand)", #body_lines - 1))
    return start, #lines - 1, true
  end

  for _, l in ipairs(body_lines) do
    table.insert(lines, l)
  end

  return start, #lines - 1, true
end

-- Builds the full buffer content for a PR plus:
-- - `actions`: 0-indexed [start, finish] ranges for the <space> keymap to
--   find what the cursor is sitting on (kind="toggle" expands/collapses a
--   review or comment body, kind="commit_diff" opens that commit's diff)
-- - `item_rows`: the 0-indexed header row of every commit/review/comment, in
--   document order, so j/k can jump straight between items instead of
--   stepping line-by-line through an expanded one's body.
local function build_pr_lines(pr, state)
  local lines = {}
  local actions = {}
  local item_rows = {}

  local author = pr.author and pr.author.login or "unknown"
  table.insert(lines, string.format("# PR #%d: %s", pr.number, pr.title))
  table.insert(lines, "")

  -- GitHub stops computing `mergeable` once a PR is closed or merged, so it
  -- always reads UNKNOWN there -- show what actually happened instead.
  local status
  if pr.state == "MERGED" then
    local merged_by = pr.mergedBy and pr.mergedBy.login or "unknown"
    local merged_at = pr.mergedAt and pr.mergedAt:sub(1, 10) or "?"
    status = string.format("MERGED by %s on %s", merged_by, merged_at)
  elseif pr.state == "CLOSED" then
    status = "CLOSED (not merged)"
  else
    status = "Mergeable: " .. (pr.mergeable or "UNKNOWN")
  end

  table.insert(lines, string.format("Author: %s   Draft: %s   %s", author, tostring(pr.isDraft), status))
  table.insert(lines, string.format("%s -> %s   +%d -%d  (%d files)",
    pr.headRefName or "?", pr.baseRefName or "?",
    pr.additions or 0, pr.deletions or 0, pr.changedFiles or 0))
  table.insert(lines, "")

  table.insert(lines, "## Description")
  if pr.body and pr.body ~= "" then
    vim.list_extend(lines, vim.split(pr.body, "\n"))
  else
    table.insert(lines, "(no description)")
  end
  table.insert(lines, "")

  table.insert(lines, string.format("## Commits (%d)", pr.commits and #pr.commits or 0))
  if pr.commits and #pr.commits > 0 then
    for _, c in ipairs(pr.commits) do
      local sha = c.oid or ""
      local row = #lines
      table.insert(lines, string.format("  %s %s", sha:sub(1, 7), c.messageHeadline or ""))
      table.insert(item_rows, row)
      if sha ~= "" then
        table.insert(actions, { start = row, finish = row, kind = "commit_diff", sha = sha })
      end
    end
  else
    table.insert(lines, "  (no commits)")
  end
  table.insert(lines, "")

  table.insert(lines, "## Reviews")
  if pr.reviews and #pr.reviews > 0 then
    for i, r in ipairs(pr.reviews) do
      local rauthor = r.author and r.author.login or "unknown"
      local header_start = #lines
      table.insert(lines, string.format("  [%s] %s", r.state, rauthor))
      table.insert(item_rows, header_start)
      local block = state.review_blocks[i]
      local _, finish, toggleable = append_review_block(lines, block)
      if toggleable then
        table.insert(actions, { start = header_start, finish = finish, kind = "toggle", block = block })
      end
    end
  else
    table.insert(lines, "  (no reviews yet)")
  end
  table.insert(lines, "")

  table.insert(lines, "## Comments")
  if pr.comments and #pr.comments > 0 then
    for i, c in ipairs(pr.comments) do
      local cauthor = c.author and c.author.login or "unknown"
      local header_start = #lines
      table.insert(lines, string.format("  %s:", cauthor))
      table.insert(item_rows, header_start)
      local block = state.comment_blocks[i]
      local _, finish = append_collapsible(lines, block, "    ")
      if #block.full_lines > 1 then
        table.insert(actions, { start = header_start, finish = finish, kind = "toggle", block = block })
      end
    end
  else
    table.insert(lines, "  (no comments)")
  end

  return lines, actions, item_rows
end

-- Lets you pick which repo to work in -- repos across every org you belong
-- to (plus your own), with the currently active one sorted first so
-- re-picking the same repo is just <CR>. <C-r> refetches the list (it's
-- cached otherwise since `gh repo list` across several orgs takes a beat).
local function pick_repo(on_picked, force_refresh)
  gh.list_repos_for_picker_async(force_refresh, function(repos)
    if not repos or #repos == 0 then
      vim.notify("No repos found", vim.log.levels.ERROR, { title = "GitHub PRs" })
      return
    end

    local active = gh.get_active_repo()
    if active then
      for i, r in ipairs(repos) do
        if r == active then
          table.remove(repos, i)
          table.insert(repos, 1, r)
          break
        end
      end
    end

    fzfLua.fzf_exec(repos, {
      prompt = "Repo (<C-r> refresh list)> ",
      actions = {
        ["default"] = function(selected) on_picked(selected[1]) end,
        ["ctrl-r"] = function() pick_repo(on_picked, true) end,
      },
    })
  end)
end

local function prompt_pr_number_in_repo(repo)
  vim.ui.input({ prompt = string.format("PR number in %s: ", repo) }, function(input)
    if not input or input:match("^%s*$") then return end

    local pr_number = input:match("^#?(%d+)$")
    if not pr_number then
      vim.notify("Invalid PR number: " .. input, vim.log.levels.ERROR, { title = "GitHub PRs" })
      return
    end

    M.review_pr(pr_number, repo)
  end)
end

-- repo is a bare "owner/repo" string; falls back to the active repo (set by
-- the <space>ap repo picker, or auto-detected from cwd) if omitted. Does all
-- the actual popup-building work, once pr (with pr.reviews already filled
-- in) is in hand -- see M.review_pr below, which fetches it asynchronously
-- and calls this when it's ready, so none of this blocks the UI.
local RELOAD_INTERVAL_MS = 10000

local function render_review_popup(pr_number, repo, pr)
  local state = build_state(pr)
  local lines, actions, item_rows = build_pr_lines(pr, state)
  local legend_lines, legend_highlights = build_legend()

  local base_title = string.format(" PR #%s (%s) ", pr_number, repo)
  local buf, win, _, footer_win = open_floating_window(lines, {
    title = base_title,
    footer = legend_lines,
    footer_highlights = legend_highlights,
  })

  render_markdown(buf, true)
  highlight_severity_tags(buf, lines)

  -- Pre-warm so the synchronous gh.get_viewer_login() calls inside
  -- mark_approved_locally/mark_merged_locally (below) almost always hit the
  -- cache instead of blocking on a "whoami" call at the moment you approve.
  gh.get_viewer_login_async(function() end)

  local function set_loading(loading)
    if not vim.api.nvim_win_is_valid(win) then return end
    pcall(vim.api.nvim_win_set_config, win, {
      title = loading and (base_title:gsub("%s*$", "") .. " ⟳ reloading... ") or base_title,
      title_pos = "center",
    })
  end

  local reload_timer

  local function close()
    if reload_timer then
      reload_timer:stop()
      reload_timer:close()
      reload_timer = nil
    end
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if footer_win and vim.api.nvim_win_is_valid(footer_win) then vim.api.nvim_win_close(footer_win, true) end
  end

  local function redraw()
    local new_lines, new_actions, new_item_rows = build_pr_lines(pr, state)
    actions = new_actions
    item_rows = new_item_rows
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
    vim.bo[buf].modifiable = false

    render_markdown(buf, false)
    highlight_severity_tags(buf, new_lines)
  end

  -- Approving/merging already tells us the exact outcome via their own
  -- success response, so there's no need to pay for a full re-fetch (a `gh
  -- pr view` plus two more `gh api` calls for reviews/comments) just to
  -- redraw -- that was most of why approve+merge felt slow, on top of the
  -- approve and merge calls themselves. Update the few fields that changed
  -- locally instead and redraw from that -- no network round trip at all.
  local function mark_approved_locally()
    local review = {
      author = { login = gh.get_viewer_login() or "you" },
      state = "APPROVED",
      body = "",
      inline_comments = {},
    }
    table.insert(pr.reviews, review)
    -- Extend state.review_blocks to match rather than rebuilding all of it,
    -- so any reviews you'd already expanded stay expanded.
    table.insert(state.review_blocks, build_review_block(review))
  end

  local function mark_merged_locally()
    pr.state = "MERGED"
    pr.mergedBy = { login = gh.get_viewer_login() or "you" }
    pr.mergedAt = os.date("!%Y-%m-%dT%H:%M:%SZ")
  end

  -- Re-fetches the PR + reviews and redraws in place. Used three ways: quietly
  -- after an optimistic local update (approve/merge, see mark_*_locally above)
  -- to reconcile any guess with real server state; on a 10s timer so the view
  -- stays current without you doing anything; and manually via <C-r> when you
  -- want it right now. Shows a loading indicator in the title except for the
  -- post-action reconcile, which is already covered by that action's own
  -- "Approved"/"Merged" notification and doesn't need a second visual cue.
  local reload_in_progress = false

  local function reload(opts)
    opts = opts or {}
    if reload_in_progress then return end
    reload_in_progress = true
    if opts.show_loading then set_loading(true) end

    gh.view_pr_json_async(pr_number, repo, function(fresh_pr, err)
      if not fresh_pr then
        reload_in_progress = false
        if opts.show_loading then set_loading(false) end
        if opts.manual then
          vim.notify("Failed to reload PR #" .. pr_number .. "\n" .. (err or ""), vim.log.levels.WARN,
            { title = "GitHub PRs" })
        end
        return
      end
      if not (vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)) then
        reload_in_progress = false
        return
      end

      gh.list_pr_reviews_with_comments_async(pr_number, repo, function(fresh_reviews)
        reload_in_progress = false
        if opts.show_loading then set_loading(false) end
        if not (vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)) then return end

        fresh_pr.reviews = fresh_reviews or fresh_pr.reviews or {}
        pr = fresh_pr
        state = build_state(pr)
        redraw()
        if opts.manual then
          vim.notify("Reloaded PR #" .. pr_number, vim.log.levels.INFO, { title = "GitHub PRs" })
        end
      end)
    end)
  end

  reload_timer = vim.uv.new_timer()
  reload_timer:start(RELOAD_INTERVAL_MS, RELOAD_INTERVAL_MS, vim.schedule_wrap(function()
    if not (vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)) then
      if reload_timer then
        reload_timer:stop()
        reload_timer:close()
        reload_timer = nil
      end
      return
    end
    reload({ show_loading = true })
  end))

  -- j/k jump straight to the next/previous commit, review or comment header
  -- instead of stepping line-by-line -- which, through an expanded review's
  -- body (summary + inline comments + diff context), could be dozens of
  -- lines of scrolling to reach the next one.
  local function jump_to_item(forward)
    local row = vim.api.nvim_win_get_cursor(win)[1] - 1
    local target

    if forward then
      for _, r in ipairs(item_rows) do
        if r > row then
          target = r
          break
        end
      end
    else
      for i = #item_rows, 1, -1 do
        if item_rows[i] < row then
          target = item_rows[i]
          break
        end
      end
    end

    if target then
      vim.api.nvim_win_set_cursor(win, { target + 1, 0 })
    end
  end

  local function handle_space_at_cursor()
    local row = vim.api.nvim_win_get_cursor(win)[1] - 1
    for _, a in ipairs(actions) do
      if row >= a.start and row <= a.finish then
        if a.kind == "toggle" then
          a.block.expanded = not a.block.expanded
          redraw()
          vim.api.nvim_win_set_cursor(win, { a.start + 1, 0 })
        elseif a.kind == "commit_diff" then
          open_commit_diff_popup(a.sha, repo)
        end
        return
      end
    end
  end

  local function do_approve_and_maybe_merge(strategy)
    vim.notify("Approving PR #" .. pr_number .. "...", vim.log.levels.INFO, { title = "GitHub PRs" })

    gh.approve_pr_async(pr_number, repo, function(approved, approve_out)
      if not approved then
        vim.notify("Failed to approve PR #" .. pr_number .. "\n" .. approve_out, vim.log.levels.ERROR,
          { title = "GitHub PR Approval Error" })
        return
      end
      vim.notify("Approved PR #" .. pr_number, vim.log.levels.INFO, { title = "GitHub PRs" })
      mark_approved_locally()

      if not strategy then
        redraw()
        reload()
        return
      end

      gh.merge_pr_async(pr_number, repo, strategy, function(merged, merge_out)
        if merged then
          vim.notify("Merged PR #" .. pr_number .. " (" .. strategy .. ")", vim.log.levels.INFO,
            { title = "GitHub PRs" })
          mark_merged_locally()
        else
          -- Best effort: approval already landed, so a failed merge (checks
          -- pending, strategy not enabled, conflicts, etc.) is not an error
          -- -- just leave it approved and mention why in case it's useful.
          vim.notify("Left PR #" .. pr_number .. " approved; merge did not go through.\n" .. vim.trim(merge_out or ""),
            vim.log.levels.WARN, { title = "GitHub PRs" })
        end

        -- Leave the popup open rather than closing it -- e.g. approving now
        -- and merging later once someone gives the go-ahead can then happen
        -- in the same sitting, from the same panel.
        redraw()
        reload()
      end)
    end)
  end

  local function do_merge_only(strategy)
    vim.notify("Merging PR #" .. pr_number .. " (no approval)...", vim.log.levels.INFO, { title = "GitHub PRs" })

    gh.merge_pr_async(pr_number, repo, strategy, function(merged, merge_out)
      if merged then
        vim.notify("Merged PR #" .. pr_number .. " (" .. strategy .. ")", vim.log.levels.INFO, { title = "GitHub PRs" })
        mark_merged_locally()
        redraw()
        reload()
      else
        -- Unlike the approve+merge flow, nothing succeeded here if the merge
        -- fails -- no approval went through either -- so this is a real error.
        vim.notify("Failed to merge PR #" .. pr_number .. "\n" .. vim.trim(merge_out or ""), vim.log.levels.ERROR,
          { title = "GitHub PR Merge Error" })
      end
    end)
  end

  local keymap_opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "a", function() do_approve_and_maybe_merge(nil) end, keymap_opts)
  vim.keymap.set("n", "m", function() do_approve_and_maybe_merge("merge") end, keymap_opts)
  vim.keymap.set("n", "s", function() do_approve_and_maybe_merge("squash") end, keymap_opts)
  vim.keymap.set("n", "r", function() do_approve_and_maybe_merge("rebase") end, keymap_opts)
  vim.keymap.set("n", "M", function() do_merge_only("merge") end, keymap_opts)

  vim.keymap.set("n", "d", function()
    open_diff_popup(pr_number, repo)
  end, keymap_opts)

  vim.keymap.set("n", "o", function()
    if IS_LINUX() then
      os.execute("xdg-open " .. vim.fn.shellescape(pr.url) .. " &")
    else
      os.execute("open " .. vim.fn.shellescape(pr.url) .. " &")
    end
    vim.notify("Opened PR #" .. pr_number .. " in browser", vim.log.levels.INFO, { title = "GitHub PRs" })
  end, keymap_opts)

  vim.keymap.set("n", "y", function()
    vim.fn.setreg("+", pr.url)
    vim.notify("Copied PR URL to clipboard", vim.log.levels.INFO, { title = "GitHub PRs" })
  end, keymap_opts)

  vim.keymap.set("n", "R", function()
    close()
    pick_repo(function(new_repo)
      gh.set_active_repo(new_repo)
      prompt_pr_number_in_repo(new_repo)
    end)
  end, keymap_opts)

  vim.keymap.set("n", "<C-r>", function() reload({ show_loading = true, manual = true }) end, keymap_opts)

  vim.keymap.set("n", "<space>", handle_space_at_cursor, keymap_opts)

  vim.keymap.set("n", "j", function() jump_to_item(true) end, keymap_opts)
  vim.keymap.set("n", "k", function() jump_to_item(false) end, keymap_opts)

  vim.keymap.set("n", "q", close, keymap_opts)
  vim.keymap.set("n", "<Esc>", close, keymap_opts)

  -- <C-h/j/k/l> and <C-w> are global window/pane-navigation keys (see
  -- wezterm-pane-switcher.lua). None of them are part of this popup's own
  -- keymap set, so pressing one here means "I'm trying to leave this popup",
  -- not "navigate while leaving it open and unfocused in the background" --
  -- just close it instead of letting the navigation run underneath it.
  for _, key in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>", "<C-w>" }) do
    vim.keymap.set("n", key, close, keymap_opts)
  end
end

-- repo is a bare "owner/repo" string; falls back to the active repo (set by
-- the <space>ap repo picker, or auto-detected from cwd) if omitted. Fetches
-- asynchronously (gh pr view, then reviews+comments) and only builds the
-- popup once both are back, so opening a PR never blocks the UI.
function M.review_pr(pr_number, repo)
  repo = repo or gh.get_active_repo()
  if not repo then
    vim.notify("Failed to determine repo", vim.log.levels.ERROR, { title = "GitHub PRs" })
    return
  end
  gh.set_active_repo(repo)

  vim.notify("Fetching PR #" .. pr_number .. " from " .. repo .. "...", vim.log.levels.INFO, { title = "GitHub PRs" })

  gh.view_pr_json_async(pr_number, repo, function(pr, err)
    if not pr then
      vim.notify("Failed to fetch PR #" .. pr_number .. "\n" .. (err or ""), vim.log.levels.ERROR,
        { title = "GitHub PRs" })
      return
    end

    gh.list_pr_reviews_with_comments_async(pr_number, repo, function(reviews, reviews_err)
      if reviews then
        pr.reviews = reviews
      else
        pr.reviews = {}
        vim.notify("Couldn't load review comments (reviews will look empty): " .. (reviews_err or ""),
          vim.log.levels.WARN, { title = "GitHub PRs" })
      end

      render_review_popup(pr_number, repo, pr)
    end)
  end)
end

-- Switches which repo <space>ap targets, via the fuzzy picker above. Its own
-- keymap (<space>ar) so picking a repo is a deliberate, occasional action
-- rather than something you're forced through on every single PR lookup.
function M.switch_repo()
  pick_repo(function(repo)
    gh.set_active_repo(repo)
    vim.notify("Active repo set to " .. repo, vim.log.levels.INFO, { title = "GitHub PRs" })
  end)
end

-- One prompt, no detour: plain "123" reviews that PR in whatever repo is
-- currently active (see <space>ar to change it), while "repo#123" or
-- "owner/repo#123" targets a different repo inline for just this one call
-- (and makes it the new active repo, since you're clearly working there now).
function M.prompt_and_review_pr()
  local active = gh.get_active_repo()
  local prompt = active and string.format("PR number (repo: %s, or repo#123 to switch): ", active)
    or "owner/repo#PR number: "

  vim.ui.input({ prompt = prompt }, function(input)
    if not input or input:match("^%s*$") then return end
    input = vim.trim(input)

    local repo_part, pr_number = input:match("^(.+)#(%d+)$")
    if not pr_number then
      pr_number = input:match("^#?(%d+)$")
      repo_part = active
    end

    if not pr_number then
      vim.notify("Expected a PR number, or 'repo#123' / 'owner/repo#123' to target a different repo",
        vim.log.levels.ERROR, { title = "GitHub PRs" })
      return
    end
    if not repo_part then
      vim.notify("No active repo yet -- use 'owner/repo#123', or <space>ar to pick one first",
        vim.log.levels.ERROR, { title = "GitHub PRs" })
      return
    end

    local repo = gh.resolve_repo_name(repo_part)
    if not repo then
      vim.notify("Couldn't resolve repo '" .. repo_part .. "' -- try <space>ar to pick it, or spell out owner/repo",
        vim.log.levels.ERROR, { title = "GitHub PRs" })
      return
    end

    M.review_pr(pr_number, repo)
  end)
end

return M
