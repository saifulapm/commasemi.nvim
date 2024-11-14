-- lua/commasemi.lua
local M = {}

local function toggle_single_line(line, character)
  if not line then return '' end

  -- First find proper comment position (handling both inline and block comments)
  local content, comment

  -- Find the earliest comment position
  local comment_pos

  -- Table of comment patterns with their starting positions
  local comment_positions = {}

  -- Look for all possible comment positions
  local patterns = {
    { pattern = '%s+//', type = 'inline' }, -- JavaScript, PHP style
    { pattern = '%s+#', type = 'inline' }, -- Python, Ruby style
    { pattern = '%s+%-%-', type = 'inline' }, -- Lua style
    { pattern = '%s+/%*', type = 'block' }, -- C-style block
    { pattern = '%s+<!%-%-', type = 'block' }, -- HTML style
    { pattern = '%s+;', type = 'inline' }, -- Assembly style
    { pattern = '%s+%%', type = 'inline' }, -- LaTeX style
    { pattern = '%s+"""', type = 'block' }, -- Python docstring
    { pattern = '%s+%%%', type = 'inline' }, -- Erlang style
    { pattern = '%s+%*', type = 'block' }, -- Doc comments
    { pattern = '%s+%<%!', type = 'block' }, -- JSP style
    { pattern = '%s+%<%%-', type = 'block' }, -- ERB style
    { pattern = '%s+///', type = 'inline' }, -- Rust doc comments
    { pattern = '%s+%[%[', type = 'block' }, -- Lua block
  }

  -- Find all comment positions
  for _, pattern in ipairs(patterns) do
    local pos = line:find(pattern.pattern)
    if pos then table.insert(comment_positions, { pos = pos, type = pattern.type }) end
  end

  -- Sort comment positions and get the earliest one
  if #comment_positions > 0 then
    table.sort(comment_positions, function(a, b) return a.pos < b.pos end)
    comment_pos = comment_positions[1].pos
  end

  -- Split line into content and comment
  if comment_pos then
    content = line:sub(1, comment_pos - 1)
    comment = line:sub(comment_pos)
  else
    content = line
    comment = ''
  end

  -- Trim trailing spaces from content
  content = content:gsub('%s*$', '')

  -- Check for both semicolon and comma at the end
  local last_char = content:sub(-1)
  local new_content

  if last_char == ',' or last_char == ';' then
    -- If already has a punctuation
    if last_char == character then
      -- Remove if same character
      new_content = content:sub(1, -2)
    else
      -- Replace with new character
      new_content = content:sub(1, -2) .. character
    end
  else
    -- Add new character if no punctuation
    new_content = content .. character
  end

  -- Reconstruct the line
  if comment ~= '' then
    return new_content .. comment -- Comment already includes leading space
  else
    return new_content
  end
end

M.toggle = function(character, mode)
  local api = vim.api

  if mode == 'visual' then
    -- Store the current visual selection
    local start_line = vim.fn.line('v')
    local end_line = vim.fn.line('.')

    -- Ensure correct order of lines
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end

    -- Process each line in the selection
    for lnum = start_line, end_line do
      local lines = api.nvim_buf_get_lines(0, lnum - 1, lnum, false)
      if lines and lines[1] then
        local new_line = toggle_single_line(lines[1], character)
        api.nvim_buf_set_lines(0, lnum - 1, lnum, false, { new_line })
      end
    end
  else
    -- Single line toggle
    local line = api.nvim_get_current_line()
    local new_line = toggle_single_line(line, character)
    api.nvim_set_current_line(new_line)
  end
end

M.setup = function(opts)
  opts = opts or {}
  local leader = opts.leader or '<localleader>'

  -- Normal mode mappings
  vim.keymap.set('n', leader .. ',', function() M.toggle(',') end, { desc = 'Toggle comma' })
  vim.keymap.set('n', leader .. ';', function() M.toggle(';') end, { desc = 'Toggle semicolon' })

  -- Visual mode mappings
  vim.keymap.set('x', leader .. ',', function() M.toggle(',', 'visual') end, { desc = 'Toggle comma in selection' })

  vim.keymap.set('x', leader .. ';', function() M.toggle(';', 'visual') end, { desc = 'Toggle semicolon in selection' })
end

return M
