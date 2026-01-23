local M = {}

local function shesc(s) return vim.fn.shellescape(s) end
local function norm(p) return vim.fs.normalize(vim.fn.fnamemodify(p, ":p")) end

-- 0 = normal live_grep_native, 1 = pick-dir-then-grep
M._dir_mode = 0

local function notify_mode()
  if M._dir_mode == 0 then
    vim.notify("fzf-lua: live_grep_native (normal)", vim.log.levels.INFO)
  else
    vim.notify("fzf-lua: pick dir -> live_grep_native", vim.log.levels.INFO)
  end
end

local function open_normal_grep()
  local fzf = require("fzf-lua")

  fzf.live_grep_native({
    -- IMPORTANT: bind ctrl-x INSIDE the fzf session
    actions = {
      ["ctrl-x"] = {
        function()
          M._dir_mode = 1
          notify_mode()
          -- switch to dir picker after this picker closes
          vim.schedule(function()
            M.pick_dir_then_grep()
          end)
        end,
        -- ensure current fzf closes before switching
        exit = true,
      },
    },
  })
end

function M.pick_dir_then_grep(opts)
  opts = opts or {}
  local fzf = require("fzf-lua")
  local root = norm(opts.cwd or vim.loop.cwd())

  local cmd = string.format(
    "cd %s && fd --type d --hidden --exclude .git --exclude node_modules --exclude dist --exclude build --strip-cwd-prefix .",
    shesc(root)
  )

  fzf.fzf_exec(cmd, {
    prompt = ("Dir> %s/ "):format(root),
    previewer = "builtin",

    actions = {
      -- Enter: grep in selected dir
      ["default"] = {
        function(selected)
          local rel = selected and selected[1]
          if not rel or rel == "" then return end
          fzf.live_grep_native({ cwd = norm(root .. "/" .. rel) })
        end,
      },

      -- Ctrl-g: grep in root
      ["ctrl-g"] = {
        function()
          fzf.live_grep_native({ cwd = root })
        end,
      },

      -- Ctrl-x: toggle back to normal mode, and switch picker immediately
      ["ctrl-x"] = {
        function()
          M._dir_mode = 0
          notify_mode()
          vim.schedule(function()
            open_normal_grep()
          end)
        end,
        exit = true,
      },
    },
  })
end

function M.run()
  if M._dir_mode == 0 then
    open_normal_grep()
  else
    M.pick_dir_then_grep()
  end
end

function M.toggle_mode()
  M._dir_mode = 1 - M._dir_mode
  notify_mode()
end

return M
