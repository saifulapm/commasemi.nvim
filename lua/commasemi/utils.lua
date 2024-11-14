local M = {}

-- Function to handle line toggle logic
function M.toggle_single_line(line, character)
  if not line then return '' end

  -- Find the earliest comment position
  local content, comment
  local comment_patterns = {
    { pattern = '%s+//' }, -- JavaScript, PHP style
    { pattern = '%s+#' }, -- Python, Ruby style
    { pattern = '%s+%-%-' }, -- Lua style
    { pattern = '%s+/%*' }, -- C-style block
    { pattern = '%s+<!%-%-' }, -- HTML style
    { pattern = '%s+;' }, -- Assembly style
    { pattern = '%s+%%' }, -- LaTeX style
    { pattern = '%s+"""' }, -- Python docstring
    { pattern = '%s+%%%' }, -- Erlang style
    { pattern = '%s+%*' }, -- Doc comments
    { pattern = '%s+%<%!' }, -- JSP style
    { pattern = '%s+%<%%-' }, -- ERB style
    { pattern = '%s+///' }, -- Rust doc comments
    { pattern = '%s+%[%[' }, -- Lua block
  }

  -- Find comment position
  local comment_pos
  for _, pattern in ipairs(comment_patterns) do
    local pos = line:find(pattern.pattern)
    if pos and (not comment_pos or pos < comment_pos) then comment_pos = pos end
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

  -- Toggle character
  local last_char = content:sub(-1)
  local new_content

  if last_char == ',' or last_char == ';' then
    if last_char == character then
      new_content = content:sub(1, -2)
    else
      new_content = content:sub(1, -2) .. character
    end
  else
    new_content = content .. character
  end

  -- Reconstruct the line
  if comment ~= '' then
    return new_content .. comment
  else
    return new_content
  end
end

return M
