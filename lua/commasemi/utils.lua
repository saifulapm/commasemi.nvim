local M = {}

-- Improved function to toggle character at end of line with better Markdown support
function M.toggle_single_line(line, character)
  if not line then return '' end

  -- Simple pattern to split line at comment
  local content, comment = line, ''

  -- Common comment patterns
  local comment_patterns = {
    '//[^"\']*$', -- C/C++/Java/JS style
    '#[^"\']*$', -- Python/Ruby/Shell style
    '%-%-[^"\']*$', -- Lua style
    '/%*.*%*/$', -- C-style block on single line
    '<!%-%-.*%-%->', -- HTML style
  }

  -- Find comment if present
  for _, pattern in ipairs(comment_patterns) do
    local s, e = line:find(pattern)
    if s then
      content = line:sub(1, s - 1)
      comment = line:sub(s)
      break
    end
  end

  -- Strip trailing whitespace
  content = content:gsub('%s*$', '')

  -- Check for quotes to avoid modifying inside strings
  local in_string = false
  local skip_modification = false
  local quote_chars = { '"', "'", '`' }

  -- Simple string detection (won't be perfect but better than nothing)
  for i = 1, #content do
    local char = content:sub(i, i)
    if vim.tbl_contains(quote_chars, char) and (i == 1 or content:sub(i - 1, i - 1) ~= '\\') then
      in_string = not in_string
    end

    -- If we're at the end and still in a string, don't modify
    if i == #content and in_string then skip_modification = true end
  end

  -- Skip modification in specific conditions
  if skip_modification then return line end

  -- Get filetype
  local filetype = vim.bo.filetype or ''
  local text_filetypes = { 'markdown', 'text', 'rst', 'org', 'txt', 'asciidoc' }
  local is_text_file = vim.tbl_contains(text_filetypes, filetype)

  -- Basic toggle logic that applies to all file types
  local last_char = content:sub(-1)

  -- Handling toggle behavior
  if last_char == character then
    -- Remove the character if it's already there
    content = content:sub(1, -2)
  elseif last_char == ',' or last_char == ';' then
    -- Replace with the new character if there's a different punctuation
    content = content:sub(1, -2) .. character
  else
    -- User can toggle it off again if they don't want it
    content = content .. character
  end

  -- Reconstruct the line
  if comment ~= '' then
    return content .. ' ' .. comment
  else
    return content
  end
end

return M
