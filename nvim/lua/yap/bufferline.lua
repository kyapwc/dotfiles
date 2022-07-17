require('bufferline').setup {
  options = {
    left_trunc_marker = '<',
    right_trunc_marker = '>',
    mode = 'buffers',
    close_command = 'bdelete! %d',
    numbers = 'ordinal',
    color_icons = true,
    show_buffer_close_icons = false,
    always_show_bufferline = true,
    name_formatter = function(buf)
      return vim.fn.fnamemodify(buf.path, ':~:t')
    end,
    max_prefix_length = 15,
    max_name_length = 30,
    show_close_icon = false,
    separator_style = 'slant',
    offsets = {
      {
        filetype = "CHADTree",
        text = function()
          return vim.fn.getcwd()
        end,
        highlight = "Directory",
        text_align = "left"
      }
    },
  }
}
