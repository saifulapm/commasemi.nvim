local M = {}
local utils = require('commasemi.utils')

function M.setup_commands()
  vim.api.nvim_create_user_command('CommaToggle', function(opts)
    if opts.range > 0 then
      for line_num = opts.line1, opts.line2 do
        local lines = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)
        if lines and lines[1] then
          local new_line = utils.toggle_single_line(lines[1], ',')
          vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })
        end
      end
    else
      local line = vim.api.nvim_get_current_line()
      local new_line = utils.toggle_single_line(line, ',')
      vim.api.nvim_set_current_line(new_line)
    end
  end, {
    desc = 'Toggle comma at the end of line(s)',
    range = true,
  })

  vim.api.nvim_create_user_command('SemiToggle', function(opts)
    if opts.range > 0 then
      for line_num = opts.line1, opts.line2 do
        local lines = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)
        if lines and lines[1] then
          local new_line = utils.toggle_single_line(lines[1], ';')
          vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { new_line })
        end
      end
    else
      local line = vim.api.nvim_get_current_line()
      local new_line = utils.toggle_single_line(line, ';')
      vim.api.nvim_set_current_line(new_line)
    end
  end, {
    desc = 'Toggle semicolon at the end of line(s)',
    range = true,
  })
end

return M
