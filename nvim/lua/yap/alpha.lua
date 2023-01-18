local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
local notify = require('notify')
local os = require('os')

dashboard.section.header.val = {
  "      ██████╗░██╗░█████╗░██╗░░██╗██╗░░░██╗██████╗░██████╗░      ",
  "      ██╔══██╗██║██╔══██╗██║░██╔╝██║░░░██║██╔══██╗██╔══██╗      ",
  "      ██████╔╝██║██║░░╚═╝█████═╝░██║░░░██║██████╔╝██████╔╝      ",
  "      ██╔═══╝░██║██║░░██╗██╔═██╗░██║░░░██║██╔═══╝░██╔═══╝░      ",
  "      ██║░░░░░██║╚█████╔╝██║░╚██╗╚██████╔╝██║░░░░░██║░░░░░      ",
  "      ╚═╝░░░░░╚═╝░╚════╝░╚═╝░░╚═╝░╚═════╝░╚═╝░░░░░╚═╝░░░░░      ",
  "                                                                ",
  "  ██╗░░░░░░░██╗███████╗██╗░░░░█████╗░██╗░░██╗██╗░░░██╗███╗░░██╗ ",
  "  ██║░░██╗░░██║██╔════╝██║░░░██╔══██╗██║░░██║██║░░░██║████╗░██║ ",
  "  ╚██╗████╗██╔╝█████╗░░██║░░░██║░░╚═╝███████║██║░░░██║██╔██╗██║ ",
  "  ░████╔═████║░██╔══╝░░██║░░░██║░░██╗██╔══██║██║░░░██║██║╚████║ ",
  "  ░╚██╔╝░╚██╔╝░███████╗██║██╗╚█████╔╝██║░░██║╚██████╔╝██║░╚███║ ",
  "  ░░╚═╝░░░╚═╝░░╚══════╝╚═╝╚═╝░╚════╝░╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝ ",
}

dashboard.section.buttons.val = {
  dashboard.button("e"     , "   New File"     , ":ene<CR>"),
  dashboard.button("s"     , "   Settings"     , ":e ~/.config/nvim/init.lua<CR>"),
  dashboard.button("SPC fp", "   Find Projects", ":Telescope projections<CR>"),
  dashboard.button("SPC q" , "   Quit"         , ":qa<CR>"),
}

local function footer()
  local total_plugin_command = io.popen('find ~/.local/share/nvim/site/pack/packer/start/ -maxdepth 1 -type d | wc -l')
  local total_plugins = total_plugin_command:read('*a')
  total_plugin_command:close()

  -- local quote_command = io.popen('fortune')
  -- local quote = quote_command:read('*a')
  -- quote_command:close()

  local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

  return datetime .. "\n  " .. Trim(total_plugins) .. " plugins loaded!\n" .. 'VIM version: ' .. nvim_version_info
end

dashboard.section.footer.opts.position = 'center'
dashboard.section.footer.val = footer()

dashboard.config.opts.noautocmd = true

alpha.setup(dashboard.opts)

vim.cmd([[
  autocmd FileType alpha setlocal nofoldenable
]])
