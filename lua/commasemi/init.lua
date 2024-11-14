local utils = require('commasemi.utils')
local commands = require('commasemi.commands')

local M = {}

M.toggle = function(character, mode)
  local api = vim.api

  if mode == 'visual' then
    local start_line = vim.fn.line('v')
    local end_line = vim.fn.line('.')

    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    for lnum = start_line, end_line do
      local lines = api.nvim_buf_get_lines(0, lnum - 1, lnum, false)
      if lines and lines[1] then
        local new_line = utils.toggle_single_line(lines[1], character)
        api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { new_line })
      end
    end
  else
    local line = api.nvim_get_current_line()
    local new_line = utils.toggle_single_line(line, character)
    api.nvim_set_current_line(new_line)
  end
end

M.setup = function(opts)
  opts = opts or {}

  -- Default config
  local config = {
    leader = '<localleader>',
    keymaps = true, -- by default keymaps are enabled
    commands = true, -- by default commands are enabled
  }

  -- Merge user config
  config = vim.tbl_deep_extend('force', config, opts)

  -- Setup keymaps only if enabled
  if config.keymaps then
    vim.keymap.set('n', config.leader .. ',', function() M.toggle(',') end, { desc = 'Toggle comma' })

    vim.keymap.set('n', config.leader .. ';', function() M.toggle(';') end, { desc = 'Toggle semicolon' })

    vim.keymap.set(
      'x',
      config.leader .. ',',
      function() M.toggle(',', 'visual') end,
      { desc = 'Toggle comma in selection' }
    )

    vim.keymap.set(
      'x',
      config.leader .. ';',
      function() M.toggle(';', 'visual') end,
      { desc = 'Toggle semicolon in selection' }
    )
  end

  -- Setup commands only if enabled
  if config.commands then commands.setup_commands() end
end

return M
