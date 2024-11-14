if vim.fn.has('nvim-0.7.0') == 0 then
  vim.api.nvim_err_writeln('commasemi requires at least nvim-0.7.0')
  return
end

-- Create initial commands only if not disabled via global variable
if vim.g.commasemi_disable_commands ~= true then
  vim.api.nvim_create_user_command('CommaToggle', function(opts)
    require('commasemi').setup()
    vim.cmd.CommaToggle(opts)
  end, {
    desc = 'Toggle comma at the end of line(s)',
    range = true,
  })

  vim.api.nvim_create_user_command('SemiToggle', function(opts)
    require('commasemi').setup()
    vim.cmd.SemiToggle(opts)
  end, {
    desc = 'Toggle semicolon at the end of line(s)',
    range = true,
  })
end
