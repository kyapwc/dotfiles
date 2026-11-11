local M = {}

local SPINNER_FRAMES = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local SPINNER_INTERVAL_MS = 90

-- Thin wrapper around nvim-notify's own `replace` support: each tick (and
-- the final result) replaces the same notification in place instead of
-- stacking a new toast, so a background job (git push, gh pr create, ...)
-- reads as one notification animating/updating rather than spam. Reuses
-- nvim-notify's existing window management and this config's own
-- `stages = 'static'` / `top_down = true` positioning (top-right) instead of
-- hand-rolling another floating-window popup.
function M.start(message)
  local id = vim.notify(SPINNER_FRAMES[1] .. " " .. message, vim.log.levels.INFO, { timeout = false }).id

  local frame = 1
  local timer = vim.uv.new_timer()
  timer:start(SPINNER_INTERVAL_MS, SPINNER_INTERVAL_MS, vim.schedule_wrap(function()
    frame = (frame % #SPINNER_FRAMES) + 1
    id = vim.notify(SPINNER_FRAMES[frame] .. " " .. message, nil, { replace = id, timeout = false }).id
  end))

  local stopped = false
  local function stop_timer()
    if stopped then return end
    stopped = true
    timer:stop()
    timer:close()
  end

  return {
    -- Swaps in the job's final message -- success, failure, whatever --
    -- and lets nvim-notify auto-dismiss it after `hold_ms` via its own
    -- timeout, instead of vanishing instantly or lingering forever.
    finish = function(final_message, hold_ms, level)
      stop_timer()
      vim.notify(final_message, level or vim.log.levels.INFO, { replace = id, timeout = hold_ms or 1500 })
    end,
    close = function()
      stop_timer()
      vim.notify(nil, nil, { replace = id, timeout = 1 })
    end,
  }
end

return M
